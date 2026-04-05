const API_URL = '/api/denuncias';

document.addEventListener("DOMContentLoaded", async function () {
    await carregarPostagens();
});

async function carregarPostagens() {
    try {
        const response = await fetch(API_URL);
        if (!response.ok) throw new Error('Erro ao carregar postagens');
        
        const postagens = await response.json();
        
        const container = document.querySelector('.grid-postagens');
        
        // Se houver postagens do banco, substitui as estáticas
        if (postagens.length > 0) {
            container.innerHTML = ''; // Limpa postagens estáticas
            
            postagens.forEach(post => {
                const divPost = criarElementoPost(post);
                container.appendChild(divPost);
            });
        }
        
        // Adiciona eventos de like para TODAS as postagens (estáticas + dinâmicas)
        adicionarEventosLike();
        
    } catch (error) {
        console.error('Erro ao carregar postagens:', error);
        alert('Erro ao carregar postagens do banco. Verifique se o servidor está rodando na porta 8080.');
    }
}

function criarElementoPost(post) {
    const div = document.createElement('div');
    div.className = 'post';
    div.dataset.id = post.id;
    
    const dataFormatada = new Date(post.dataCriacao).toLocaleDateString('pt-BR');
    
    div.innerHTML = `
        <h3 class="post-title">${post.titulo}</h3>
        ${post.imagemBase64 ? `<img src="${post.imagemBase64}" alt="${post.titulo}">` : ''}
        <p class="post-desc">${post.descricao}</p>
        <p class="post-local"><strong>📍 Local:</strong> ${post.local}</p>
        <p class="post-data"><strong>📅 Data:</strong> ${dataFormatada}</p>
        <button class="like-btn" data-id="${post.id}">👍 ${post.likes || 0}</button>
    `;
    
    return div;
}

function adicionarEventosLike() {
    const botoes = document.querySelectorAll(".like-btn");
    
    botoes.forEach((btn) => {
        btn.addEventListener("click", async () => {
            if (btn.dataset.clicked === "true") return;
            
            const postId = btn.dataset.id;
            
            // Se não tem ID (postagens estáticas antigas), apenas incrementa localmente
            if (!postId) {
                let texto = btn.textContent;
                let numeroLikes = parseInt(texto.replace(/[^\d]/g, ""));
                numeroLikes++;
                btn.textContent = `👍 ${numeroLikes}`;
                btn.dataset.clicked = "true";
                btn.classList.add("clicked");
                setTimeout(() => btn.classList.remove("clicked"), 400);
                return;
            }
            
            // Para postagens do banco, incrementa no servidor
            try {
                const response = await fetch(`${API_URL}/${postId}/like`, {
                    method: 'PATCH'
                });
                
                if (response.ok) {
                    const postagemAtualizada = await response.json();
                    btn.textContent = `👍 ${postagemAtualizada.likes}`;
                    btn.dataset.clicked = "true";
                    btn.classList.add("clicked");
                    
                    setTimeout(() => {
                        btn.classList.remove("clicked");
                    }, 400);
                } else {
                    alert('Erro ao registrar like');
                }
            } catch (error) {
                console.error('Erro ao dar like:', error);
                alert('Erro de conexão ao dar like');
            }
        });
    });
}
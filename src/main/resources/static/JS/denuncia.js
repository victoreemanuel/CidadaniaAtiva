
const API_URL = '/api/denuncias';

document.addEventListener("DOMContentLoaded", function () {
    const checkbox = document.getElementById("anonimo");
    const form = document.querySelector(".formulario-denuncia");
    const botao = document.querySelector("button[type='submit']");
    const LIMITE_MB = 5;

    botao.disabled = !checkbox.checked;

    checkbox.addEventListener("change", function () {
        botao.disabled = !this.checked;
    });

    form.addEventListener("submit", function (e) {
        e.preventDefault();

        const titulo = document.getElementById("nome").value.trim();
        const local = document.getElementById("endereco").value.trim();
        const descricao = document.getElementById("ocorrencia").value.trim();
        const arquivo = document.getElementById("arquivo").files[0];

        if (!titulo || !local || !descricao) {
            alert("Por favor, preencha todos os campos obrigatórios.");
            return;
        }

        if (arquivo) {
            if (arquivo.size > LIMITE_MB * 1024 * 1024) {
                alert("A imagem excede o limite de 5MB. Por favor, envie uma imagem menor.");
                return;
            }

            const reader = new FileReader();
            reader.onload = function (event) {
                enviarDenunciaParaBackend(titulo, local, descricao, event.target.result);
            };
            reader.onerror = function() {
                alert("Erro ao ler o arquivo de imagem.");
            };
            reader.readAsDataURL(arquivo);
        } else {
            enviarDenunciaParaBackend(titulo, local, descricao, null);
        }
    });

    // Função para enviar para o backend (Spring Boot)
    async function enviarDenunciaParaBackend(titulo, local, descricao, imagemBase64) {
        const denuncia = {
            titulo: titulo,
            local: local,
            descricao: descricao,
            imagemBase64: imagemBase64,
            likes: 0
        };

        console.log("Enviando denúncia para o backend:", denuncia);

        try {
            const response = await fetch(API_URL, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(denuncia)
            });

            console.log("Status da resposta:", response.status);

            if (response.ok) {
                const denunciaSalva = await response.json();
                console.log("Denúncia salva com sucesso:", denunciaSalva);
                
                alert("Denúncia registrada com sucesso ");
                form.reset();
                botao.disabled = true;
                
            } else {
                const errorText = await response.text();
                console.error("Erro na resposta do servidor:", errorText);
                alert("Erro ao registrar denúncia. Status: " + response.status + "\nDetalhes: " + errorText);
            }
        } catch (error) {
            console.error('Erro de conexão:', error);
            alert("Erro de conexão com o servidor!\n\nVerifique:\n1. Se o Spring Boot está rodando (IntelliJ)\n2. Se está rodando na porta 8080\n3. Se não há erro de CORS\n\nErro: " + error.message);
        }
    }
});
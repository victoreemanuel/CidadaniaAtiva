package com.aep.cidadaniaativa.service;

import com.aep.cidadaniaativa.model.Postagem;
import com.aep.cidadaniaativa.repository.PostagemRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class PostagemService {

    @Autowired
    private PostagemRepository repository;

    public List<Postagem> listarTodas() {
        // Ordena por data de criação decrescente (mais recentes primeiro)
        return repository.findAllByOrderByDataCriacaoDesc();
    }

    public Optional<Postagem> buscarPorId(Long id) {
        return repository.findById(id);
    }

    public Postagem salvar(Postagem postagem) {
        return repository.save(postagem);
    }

    public Postagem incrementarLike(Postagem postagem) {
        // Se likes for null, inicializa com 0
        if (postagem.getLikes() == null) {
            postagem.setLikes(0);
        }
        postagem.setLikes(postagem.getLikes() + 1);
        return repository.save(postagem);
    }

    public void deletar(Long id) {
        repository.deleteById(id);
    }
}
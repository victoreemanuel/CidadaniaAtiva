package com.aep.cidadaniaativa.controller;

import com.aep.cidadaniaativa.model.Postagem;
import com.aep.cidadaniaativa.service.PostagemService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/denuncias")
@CrossOrigin(origins = "*", allowedHeaders = "*")  // IMPORTANTE!
public class PostagemController {

    @Autowired
    private PostagemService service;

    @GetMapping
    public ResponseEntity<List<Postagem>> listarTodas() {
        List<Postagem> postagens = service.listarTodas();
        return ResponseEntity.ok(postagens);
    }

    @PostMapping
    public ResponseEntity<Postagem> criar(@RequestBody Postagem postagem) {
        System.out.println("📩 Recebendo denúncia: " + postagem.getTitulo());
        postagem.setDataCriacao(LocalDateTime.now());
        if (postagem.getLikes() == null) {
            postagem.setLikes(0);
        }
        Postagem novaPostagem = service.salvar(postagem);
        System.out.println("✅ Denúncia salva com ID: " + novaPostagem.getId());
        return ResponseEntity.ok(novaPostagem);
    }

    @PatchMapping("/{id}/like")
    public ResponseEntity<Postagem> darLike(@PathVariable Long id) {
        Optional<Postagem> postagemOpt = service.buscarPorId(id);
        if (postagemOpt.isEmpty()) {
            return ResponseEntity.notFound().build();
        }

        Postagem postagem = postagemOpt.get();
        Postagem atualizada = service.incrementarLike(postagem);
        return ResponseEntity.ok(atualizada);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletar(@PathVariable Long id) {
        Optional<Postagem> postagemOpt = service.buscarPorId(id);
        if (postagemOpt.isEmpty()) {
            return ResponseEntity.notFound().build();
        }
        service.deletar(id);
        return ResponseEntity.noContent().build();
    }
}

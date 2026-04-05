package com.aep.cidadaniaativa.model;

import jakarta.persistence.*;
import lombok.Data;

import java.time.LocalDateTime;

@Entity
@Table(name= "postagem")
@Data
public class Postagem {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "data_criacao", nullable = false)
    private LocalDateTime dataCriacao;

    @Column(columnDefinition = "TEXT")
    private String descricao;

    @Column(name = "imagem_base64", columnDefinition = "LONGTEXT")
    private String imagemBase64;

    @Column(length = 255)
    private String local;

    @Column(length = 255)
    private String titulo;

    // Campo para armazenar os likes
    @Column(nullable = false)
    private Integer likes = 0;  // Inicia com 0 likes

    // Método para definir a data automaticamente antes de salvar
    @PrePersist
    protected void onCreate() {
        if (dataCriacao == null) {
            dataCriacao = LocalDateTime.now();
        }
        if (likes == null) {
            likes = 0;
        }
    }
}
package com.aep.cidadaniaativa.repository;

import com.aep.cidadaniaativa.model.Postagem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PostagemRepository extends JpaRepository<Postagem, Long> {
    // Busca todas ordenadas por data de criação decrescente
    List<Postagem> findAllByOrderByDataCriacaoDesc();
}

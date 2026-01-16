package com.b2.tp1.repository;

import com.b2.tp1.model.Task;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Repository
public class TaskRepository {

    // Stockage en mémoire avec une Map
    private final Map<Long, Task> tasks = new HashMap<>();
    
    // Compteur pour générer les IDs automatiquement
    private Long currentId = 1L;

    // Récupérer toutes les tâches
    public List<Task> findAll() {
        return new ArrayList<>(tasks.values());
    }

    // Récupérer une tâche par son ID
    public Optional<Task> findById(Long id) {
        return Optional.ofNullable(tasks.get(id));
    }

    // Sauvegarder une nouvelle tâche (génère l'ID)
    public Task save(Task task) {
        if (task.getId() == null) {
            task.setId(currentId++);
        }
        tasks.put(task.getId(), task);
        return task;
    }

    // Mettre à jour une tâche existante
    public Task update(Task task) {
        tasks.put(task.getId(), task);
        return task;
    }

    // Supprimer une tâche par son ID
    public void deleteById(Long id) {
        tasks.remove(id);
    }

    // Vérifier si une tâche existe
    public boolean existsById(Long id) {
        return tasks.containsKey(id);
    }
}

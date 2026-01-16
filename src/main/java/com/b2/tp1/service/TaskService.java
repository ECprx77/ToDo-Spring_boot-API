package com.b2.tp1.service;

import com.b2.tp1.model.Task;
import com.b2.tp1.repository.TaskRepository;
import org.springframework.stereotype.Service;

import java.util.Arrays;
import java.util.List;
import java.util.NoSuchElementException;

@Service
public class TaskService {

    private final TaskRepository taskRepository;

    // Liste des statuts valides
    private static final List<String> VALID_STATUSES = Arrays.asList("TODO", "IN_PROGRESS", "DONE");

    public TaskService(TaskRepository taskRepository) {
        this.taskRepository = taskRepository;
    }

    // Récupérer toutes les tâches
    public List<Task> getAllTasks() {
        return taskRepository.findAll();
    }

    // Récupérer une tâche par son ID
    public Task getTaskById(Long id) {
        return taskRepository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("Task not found"));
    }

    // Créer une nouvelle tâche
    public Task createTask(Task task) {
        // Vérifier que le titre n'est pas vide ou null
        if (task.getTitle() == null || task.getTitle().trim().isEmpty()) {
            throw new IllegalArgumentException("Title is required");
        }

        // Si pas de status, mettre TODO par défaut
        if (task.getStatus() == null || task.getStatus().trim().isEmpty()) {
            task.setStatus("TODO");
        } else {
            // Vérifier que le status est valide
            if (!VALID_STATUSES.contains(task.getStatus())) {
                throw new IllegalArgumentException("Invalid status. Must be TODO, IN_PROGRESS or DONE");
            }
        }

        // L'ID sera généré par le repository
        task.setId(null);
        return taskRepository.save(task);
    }

    // Mettre à jour complètement une tâche (PUT)
    public Task updateTask(Long id, Task task) {
        // Vérifier que la tâche existe
        if (!taskRepository.existsById(id)) {
            throw new NoSuchElementException("Task not found");
        }

        // Vérifier que le titre n'est pas vide
        if (task.getTitle() == null || task.getTitle().trim().isEmpty()) {
            throw new IllegalArgumentException("Title is required");
        }

        // Vérifier que le status est valide
        if (task.getStatus() != null && !VALID_STATUSES.contains(task.getStatus())) {
            throw new IllegalArgumentException("Invalid status. Must be TODO, IN_PROGRESS or DONE");
        }

        task.setId(id);
        return taskRepository.update(task);
    }

    // Mettre à jour uniquement le status (PATCH)
    public Task updateTaskStatus(Long id, String status) {
        // Vérifier que la tâche existe
        Task existingTask = taskRepository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("Task not found"));

        // Vérifier que le status est valide
        if (status == null || !VALID_STATUSES.contains(status)) {
            throw new IllegalArgumentException("Invalid status. Must be TODO, IN_PROGRESS or DONE");
        }

        existingTask.setStatus(status);
        return taskRepository.update(existingTask);
    }

    // Supprimer une tâche
    public void deleteTask(Long id) {
        // Vérifier que la tâche existe
        if (!taskRepository.existsById(id)) {
            throw new NoSuchElementException("Task not found");
        }

        taskRepository.deleteById(id);
    }
}

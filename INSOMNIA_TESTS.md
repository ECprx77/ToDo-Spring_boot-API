# Tests API ToDo avec Insomnia/Postman

## Configuration de base
- **URL de base** : `http://localhost:8080`
- **Content-Type** : `application/json`

---

## 1. CRÉATION DE TÂCHES (POST)

### Requête 1 - Créer une tâche complète
```
POST http://localhost:8080/api/tasks/ajouter
```
**Body (JSON)** :
```json
{
    "title": "Préparer le cours REST",
    "description": "Réviser les concepts HTTP et REST",
    "status": "TODO",
    "dueDate": "2026-01-20"
}
```
**Réponse attendue** : `201 Created`

---

### Requête 2 - Créer une tâche minimale
```
POST http://localhost:8080/api/tasks/ajouter
```
**Body (JSON)** :
```json
{
    "title": "Acheter du café"
}
```
**Réponse attendue** : `201 Created` (status sera automatiquement "TODO")

---

### Requête 3 - Créer une tâche en cours
```
POST http://localhost:8080/api/tasks/ajouter
```
**Body (JSON)** :
```json
{
    "title": "Développer l'API ToDo",
    "description": "Implémenter les endpoints CRUD",
    "status": "IN_PROGRESS",
    "dueDate": "2026-01-15"
}
```
**Réponse attendue** : `201 Created`

---

### Requête 4 - ERREUR : Titre manquant (test 400)
```
POST http://localhost:8080/api/tasks/ajouter
```
**Body (JSON)** :
```json
{
    "description": "Tâche sans titre"
}
```
**Réponse attendue** : `400 Bad Request`
```json
{
    "message": "Title is required"
}
```

---

## 2. RÉCUPÉRATION DE TOUTES LES TÂCHES (GET)

### Requête - Liste des tâches
```
GET http://localhost:8080/api/tasks/Afficher
```
**Réponse attendue** : `200 OK` avec un tableau JSON de toutes les tâches

---

## 3. RÉCUPÉRATION PAR ID (GET)

### Requête - Tâche existante (id = 1)
```
GET http://localhost:8080/api/tasks/Afficher/1
```
**Réponse attendue** : `200 OK`

---

### Requête - Tâche inexistante (id = 999)
```
GET http://localhost:8080/api/tasks/Afficher/999
```
**Réponse attendue** : `404 Not Found`
```json
{
    "message": "Task not found"
}
```

---

## 4. MISE À JOUR COMPLÈTE (PUT)

### Requête - Modifier la tâche 1
```
PUT http://localhost:8080/api/tasks/modifier/1
```
**Body (JSON)** :
```json
{
    "title": "Cours REST - MODIFIÉ",
    "description": "Nouvelle description mise à jour",
    "status": "IN_PROGRESS",
    "dueDate": "2026-01-25"
}
```
**Réponse attendue** : `200 OK`

---

### Requête - Modifier une tâche inexistante
```
PUT http://localhost:8080/api/tasks/modifier/999
```
**Body (JSON)** :
```json
{
    "title": "Test"
}
```
**Réponse attendue** : `404 Not Found`

---

## 5. MISE À JOUR DU STATUS (PATCH)

### Requête - Changer le status en DONE
```
PATCH http://localhost:8080/api/tasks/modifierstatus/1/status
```
**Body (JSON)** :
```json
{
    "status": "DONE"
}
```
**Réponse attendue** : `200 OK`

---

### Requête - Status invalide (test 400)
```
PATCH http://localhost:8080/api/tasks/modifierstatus/1/status
```
**Body (JSON)** :
```json
{
    "status": "INVALID"
}
```
**Réponse attendue** : `400 Bad Request`
```json
{
    "message": "Invalid status. Must be TODO, IN_PROGRESS or DONE"
}
```

---

## 6. SUPPRESSION (DELETE)

### Requête - Supprimer la tâche 2
```
DELETE http://localhost:8080/api/tasks/supprimer/2
```
**Réponse attendue** : `204 No Content`

---

### Requête - Vérifier la suppression
```
GET http://localhost:8080/api/tasks/Afficher/2
```
**Réponse attendue** : `404 Not Found`

---

### Requête - Supprimer une tâche inexistante
```
DELETE http://localhost:8080/api/tasks/supprimer/999
```
**Réponse attendue** : `404 Not Found`

---

## Résumé des endpoints

| Méthode | URL | Description | Code succès |
|---------|-----|-------------|-------------|
| GET | `/api/tasks/Afficher` | Liste toutes les tâches | 200 |
| GET | `/api/tasks/Afficher/{id}` | Récupère une tâche | 200 |
| POST | `/api/tasks/ajouter` | Crée une tâche | 201 |
| PUT | `/api/tasks/modifier/{id}` | Modifie entièrement | 200 |
| PATCH | `/api/tasks/modifierstatus/{id}/status` | Modifie le status | 200 |
| DELETE | `/api/tasks/supprimer/{id}` | Supprime une tâche | 204 |

## Codes d'erreur

| Code | Signification |
|------|---------------|
| 400 | Données invalides (titre manquant, status invalide) |
| 404 | Tâche non trouvée |
| 500 | Erreur serveur |

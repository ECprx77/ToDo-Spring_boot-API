#!/bin/bash

# Script de test de l'API ToDo
# Assurez-vous que l'application Spring Boot tourne sur localhost:8080

BASE_URL="http://localhost:8080/api/tasks"

echo "========================================"
echo "   TEST DE L'API ToDo - Spring Boot"
echo "========================================"
echo ""

# Couleurs
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Fonction pour afficher le résultat
print_result() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✓ SUCCÈS${NC}"
    else
        echo -e "${RED}✗ ÉCHEC${NC}"
    fi
}

# ========================================
# 1. TEST POST - Créer des tâches
# ========================================
echo -e "${YELLOW}1. CRÉATION DE TÂCHES (POST)${NC}"
echo "----------------------------------------"

echo -n "Création tâche 1... "
RESPONSE1=$(curl -s -w "\n%{http_code}" -X POST "$BASE_URL/ajouter" \
    -H "Content-Type: application/json" \
    -d '{"title": "Préparer le cours REST", "description": "Réviser les concepts HTTP", "status": "TODO", "dueDate": "2026-01-20"}')
HTTP_CODE=$(echo "$RESPONSE1" | tail -1)
BODY=$(echo "$RESPONSE1" | head -n -1)
[ "$HTTP_CODE" = "201" ] && print_result 0 || print_result 1
echo "   Réponse: $BODY"
echo ""

echo -n "Création tâche 2... "
RESPONSE2=$(curl -s -w "\n%{http_code}" -X POST "$BASE_URL/ajouter" \
    -H "Content-Type: application/json" \
    -d '{"title": "Acheter du café"}')
HTTP_CODE=$(echo "$RESPONSE2" | tail -1)
BODY=$(echo "$RESPONSE2" | head -n -1)
[ "$HTTP_CODE" = "201" ] && print_result 0 || print_result 1
echo "   Réponse: $BODY"
echo ""

echo -n "Création tâche 3... "
RESPONSE3=$(curl -s -w "\n%{http_code}" -X POST "$BASE_URL/ajouter" \
    -H "Content-Type: application/json" \
    -d '{"title": "Développer API ToDo", "description": "Implémenter CRUD", "status": "IN_PROGRESS", "dueDate": "2026-01-15"}')
HTTP_CODE=$(echo "$RESPONSE3" | tail -1)
BODY=$(echo "$RESPONSE3" | head -n -1)
[ "$HTTP_CODE" = "201" ] && print_result 0 || print_result 1
echo "   Réponse: $BODY"
echo ""

echo -n "Test erreur 400 (titre manquant)... "
RESPONSE_ERR=$(curl -s -w "\n%{http_code}" -X POST "$BASE_URL/ajouter" \
    -H "Content-Type: application/json" \
    -d '{"description": "Pas de titre"}')
HTTP_CODE=$(echo "$RESPONSE_ERR" | tail -1)
BODY=$(echo "$RESPONSE_ERR" | head -n -1)
[ "$HTTP_CODE" = "400" ] && print_result 0 || print_result 1
echo "   Réponse: $BODY"
echo ""

# ========================================
# 2. TEST GET - Récupérer toutes les tâches
# ========================================
echo -e "${YELLOW}2. RÉCUPÉRATION DE TOUTES LES TÂCHES (GET)${NC}"
echo "----------------------------------------"

echo -n "GET /api/tasks/Afficher... "
RESPONSE=$(curl -s -w "\n%{http_code}" "$BASE_URL/Afficher")
HTTP_CODE=$(echo "$RESPONSE" | tail -1)
BODY=$(echo "$RESPONSE" | head -n -1)
[ "$HTTP_CODE" = "200" ] && print_result 0 || print_result 1
echo "   Réponse: $BODY"
echo ""

# ========================================
# 3. TEST GET par ID
# ========================================
echo -e "${YELLOW}3. RÉCUPÉRATION PAR ID (GET)${NC}"
echo "----------------------------------------"

echo -n "GET tâche id=1 (existante)... "
RESPONSE=$(curl -s -w "\n%{http_code}" "$BASE_URL/Afficher/1")
HTTP_CODE=$(echo "$RESPONSE" | tail -1)
BODY=$(echo "$RESPONSE" | head -n -1)
[ "$HTTP_CODE" = "200" ] && print_result 0 || print_result 1
echo "   Réponse: $BODY"
echo ""

echo -n "GET tâche id=999 (inexistante - 404)... "
RESPONSE=$(curl -s -w "\n%{http_code}" "$BASE_URL/Afficher/999")
HTTP_CODE=$(echo "$RESPONSE" | tail -1)
BODY=$(echo "$RESPONSE" | head -n -1)
[ "$HTTP_CODE" = "404" ] && print_result 0 || print_result 1
echo "   Réponse: $BODY"
echo ""

# ========================================
# 4. TEST PUT - Mise à jour complète
# ========================================
echo -e "${YELLOW}4. MISE À JOUR COMPLÈTE (PUT)${NC}"
echo "----------------------------------------"

echo -n "PUT tâche id=1... "
RESPONSE=$(curl -s -w "\n%{http_code}" -X PUT "$BASE_URL/modifier/1" \
    -H "Content-Type: application/json" \
    -d '{"title": "Cours REST - MODIFIÉ", "description": "Nouvelle description", "status": "IN_PROGRESS", "dueDate": "2026-01-25"}')
HTTP_CODE=$(echo "$RESPONSE" | tail -1)
BODY=$(echo "$RESPONSE" | head -n -1)
[ "$HTTP_CODE" = "200" ] && print_result 0 || print_result 1
echo "   Réponse: $BODY"
echo ""

# ========================================
# 5. TEST PATCH - Mise à jour du status
# ========================================
echo -e "${YELLOW}5. MISE À JOUR DU STATUS (PATCH)${NC}"
echo "----------------------------------------"

echo -n "PATCH status=DONE pour tâche 1... "
RESPONSE=$(curl -s -w "\n%{http_code}" -X PATCH "$BASE_URL/modifierstatus/1/status" \
    -H "Content-Type: application/json" \
    -d '{"status": "DONE"}')
HTTP_CODE=$(echo "$RESPONSE" | tail -1)
BODY=$(echo "$RESPONSE" | head -n -1)
[ "$HTTP_CODE" = "200" ] && print_result 0 || print_result 1
echo "   Réponse: $BODY"
echo ""

echo -n "PATCH status invalide (400)... "
RESPONSE=$(curl -s -w "\n%{http_code}" -X PATCH "$BASE_URL/modifierstatus/1/status" \
    -H "Content-Type: application/json" \
    -d '{"status": "INVALID"}')
HTTP_CODE=$(echo "$RESPONSE" | tail -1)
BODY=$(echo "$RESPONSE" | head -n -1)
[ "$HTTP_CODE" = "400" ] && print_result 0 || print_result 1
echo "   Réponse: $BODY"
echo ""

# ========================================
# 6. TEST DELETE - Suppression
# ========================================
echo -e "${YELLOW}6. SUPPRESSION (DELETE)${NC}"
echo "----------------------------------------"

echo -n "DELETE tâche id=2... "
RESPONSE=$(curl -s -w "\n%{http_code}" -X DELETE "$BASE_URL/supprimer/2")
HTTP_CODE=$(echo "$RESPONSE" | tail -1)
[ "$HTTP_CODE" = "204" ] && print_result 0 || print_result 1
echo ""

echo -n "Vérification suppression (GET id=2 -> 404)... "
RESPONSE=$(curl -s -w "\n%{http_code}" "$BASE_URL/Afficher/2")
HTTP_CODE=$(echo "$RESPONSE" | tail -1)
BODY=$(echo "$RESPONSE" | head -n -1)
[ "$HTTP_CODE" = "404" ] && print_result 0 || print_result 1
echo "   Réponse: $BODY"
echo ""

# ========================================
# RÉSUMÉ FINAL
# ========================================
echo "========================================"
echo -e "${YELLOW}   ÉTAT FINAL DES TÂCHES${NC}"
echo "========================================"
curl -s "$BASE_URL/Afficher" | python3 -m json.tool 2>/dev/null || curl -s "$BASE_URL/Afficher"
echo ""
echo "========================================"
echo -e "${GREEN}   TESTS TERMINÉS !${NC}"
echo "========================================"

def categorize_article(article: dict, topics: list) -> list[int]:
    """
    Compare le titre + contenu d'un article avec les mots-clés de chaque topic.
    Retourne la liste des topic_ids qui correspondent.
    """
    # On fusionne titre + contenu en minuscules pour la comparaison
    text = f"{article['title']} {article['content']}".lower()

    matched_topic_ids = []

    for topic in topics:
        keywords = topic.keywords or []
        for keyword in keywords:
            if keyword.lower() in text:
                matched_topic_ids.append(topic.id)
                break  # Un seul mot-clé suffit pour matcher ce topic

    return matched_topic_ids


def categorize_all(articles: list[dict], topics: list) -> list[dict]:
    """
    Pour chaque article, trouve ses topics correspondants.
    Retourne les articles enrichis avec leur liste de topic_ids.
    """
    results = []
    unmatched = 0

    for article in articles:
        topic_ids = categorize_article(article, topics)

        if topic_ids:
            article["topic_ids"] = topic_ids
            results.append(article)
        else:
            unmatched += 1

    print(f"✅ {len(results)} articles catégorisés")
    print(f"⚠️  {unmatched} articles sans topic correspondant (ignorés)")

    return results

# airflow/Dockerfile
FROM apache/airflow:2.8.1-python3.10

# Installez les dépendances Python supplémentaires
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Créez des répertoires pour les logs et les DAGs et définissez les permissions
RUN mkdir -p /opt/airflow/logs /opt/airflow/dags \
    && chown -R $${AIRFLOW_UID}:$${AIRFLOW_UID} /opt/airflow/logs /opt/airflow/dags \
    && chmod -R 755 /opt/airflow/logs /opt/airflow/dags

# Installez envsubst (utile pour générer profiles.yml à partir du template)
RUN apt-get update && apt-get install -y gettext-base && rm -rf /var/lib/apt/lists/*

# Générez le profiles.yml de dbt au démarrage du conteneur
# Ceci assure que le profiles.yml est créé avec les variables d'environnement du conteneur
# Le script d'entrée s'exécute pour tous les services Airflow et dbt_cli
RUN printf "#!/bin/bash\nset -e\nif [ \"\$1\" = \"webserver\" ] || [ \"\$1\" = \"scheduler\" ] || [ \"\$1\" = \"worker\" ] || [ \"\$1\" = \"tail\" ]; then\n  if [ -f \"$${DBT_PROFILES_DIR}/profiles.yml.template\" ]; then\n    envsubst < \"$${DBT_PROFILES_DIR}/profiles.yml.template\" > \"$${DBT_PROFILES_DIR}/enterprise_dw/profiles.yml\"\n  fi\nfi\nexec \"\$@\"\n" > /entrypoint.sh \
    && chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["webserver"] # Default command, overridden by docker-compose

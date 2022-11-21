# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

# Pick your favorite docker-stacks image
FROM jupyter/all-spark-notebook:spark-3.3.1

USER root

# Add permanent apt-get installs and other root commands here
# e.g., RUN apt-get install --yes --no-install-recommends npm nodejs
RUN apt-get install --yes --no-install-recommends gcc

USER ${NB_UID}

# Switch back to jovyan to avoid accidental container runs as root
# Add permanent mamba/pip/conda installs, data files, other user libs here
# e.g., RUN pip install --quiet --no-cache-dir flake8
# install a package into the default (python 3.x) environment and cleanup after
# the installation
COPY --chown=${NB_UID}:${NB_GID} requirements.txt /tmp/

RUN conda install --quiet --yes gcc && \
    conda clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

RUN pip install --quiet --no-cache-dir --requirement /tmp/requirements.txt && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

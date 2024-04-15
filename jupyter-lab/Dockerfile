FROM quay.io/jupyter/minimal-notebook:2024-04-01

RUN pip install --upgrade --ignore-installed --force-reinstall jupyterlab_widgets==3.0.10
COPY requirements.txt ./
RUN pip install -r requirements.txt && jupyter lab build


FROM squidfunk/mkdocs-material

COPY requirements.txt requirements.txt
RUN pip install --force-reinstall -r requirements.txt

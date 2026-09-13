.PHONY: help \
	kustomize-base \
	kustomize-dev \
	helm-lint \
	helm-template \
	argocd-validate \
	validate

KUSTOMIZE_BASE=apps/demo/base
KUSTOMIZE_DEV=apps/demo/overlays/dev
HELM_CHART=helm/demo

help:
	@echo "Comandos disponíveis:"
	@echo "  make kustomize-base   - Renderiza a base Kustomize"
	@echo "  make kustomize-dev    - Renderiza o overlay dev"
	@echo "  make helm-lint        - Valida o Helm Chart"
	@echo "  make helm-template    - Renderiza o Helm Chart"
	@echo "  make argocd-validate  - Valida os manifests do ArgoCD"
	@echo "  make validate         - Executa todas as validações"

kustomize-base:
	kubectl kustomize $(KUSTOMIZE_BASE)

kustomize-dev:
	kubectl kustomize $(KUSTOMIZE_DEV)

helm-lint:
	helm lint $(HELM_CHART)

helm-template:
	helm template demo $(HELM_CHART)

argocd-validate:
	kubectl apply --dry-run=client --validate=false -f argocd/projects/dev-project.yaml
	kubectl apply --dry-run=client --validate=false -f argocd/applications/demo-app.yaml

validate:
	$(MAKE) kustomize-base
	$(MAKE) kustomize-dev
	$(MAKE) helm-lint
	$(MAKE) helm-template
	$(MAKE) argocd-validate
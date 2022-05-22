export OWLET_CONFIGURATION=~/owlet/ci-kit/bin/python/configuration
export OWLET_PYPROJECT_FILE=${OWLET_CONFIGURATION}/pyproject.toml
export OWLET_COVERAGERC_FILE=${OWLET_CONFIGURATION}/.coveragerc

alias owlet_black="black --config $OWLET_PYPROJECT_FILE"
alias owlet_isort="isort --sp $OWLET_PYPROJECT_FILE"
alias owlet_lint_all="isort --sp $OWLET_PYPROJECT_FILE --src . .  && black --config $OWLET_PYPROJECT_FILE ."

alias owlet_pylint_global="pylint --rcfile=${OWLET_CONFIGURATION}/pylint_global.toml"
alias owlet_pylint_global_oas="pylint -j 2 --rcfile=${OWLET_CONFIGURATION}/pylint_global.toml --ignore=app/models"
alias owlet_pylint_models="pylint --rcfile=${OWLET_CONFIGURATION}/pylint_generated_models.toml"
alias owlet_pylint_tests="pylint --rcfile=${OWLET_CONFIGURATION}/pylint_tests.toml"

alias owlet_test_all="python -m pytest --cov=./ --cov-branch --cov-config=$OWLET_COVERAGERC_FILE ./tests"
alias owlet_test_unit="python -m pytest --cov=./ --cov-branch --cov-config=$OWLET_COVERAGERC_FILE ./tests/unit"
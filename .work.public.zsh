export PATH="$VOLTA_HOME/bin:$PATH"
export PATH="/Users/dmossaband/.local/bin:$PATH"
export PATH="/usr/local/opt/openssl@3/bin:$PATH"

export VOLTA_HOME=$HOME/.volta

export OWLET_CONFIGURATION=~/owlet/ci-kit/bin/python/configuration
export OWLET_PYPROJECT_FILE=${OWLET_CONFIGURATION}/pyproject.toml
export OWLET_COVERAGERC_FILE=${OWLET_CONFIGURATION}/.coveragerc


export LDFLAGS="-L/usr/local/opt/openssl@3/lib"
export CPPFLAGS="-I/usr/local/opt/openssl@3/include"
export WORKON_HOME=$HOME/.virtualenvs

export PYENV_ROOT="$HOME/.pyenv"
export PYENV_VIRTUALENVWRAPPER_PREFER_PYVENV="true"

command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"

alias owlet_black="black --config $OWLET_PYPROJECT_FILE"
alias owlet_isort="isort --sp $OWLET_PYPROJECT_FILE"
alias owlet_lint_all="isort --sp $OWLET_PYPROJECT_FILE --src . .  && black --config $OWLET_PYPROJECT_FILE ."

alias owlet_pylint_global="pylint --rcfile=${OWLET_CONFIGURATION}/pylint_global.toml"
alias owlet_pylint_global_oas="pylint -j 2 --rcfile=${OWLET_CONFIGURATION}/pylint_global.toml --ignore=app/models"
alias owlet_pylint_models="pylint --rcfile=${OWLET_CONFIGURATION}/pylint_generated_models.toml"
alias owlet_pylint_tests="pylint --rcfile=${OWLET_CONFIGURATION}/pylint_tests.toml"

alias owlet_test_all="python -m pytest --cov=./ --cov-branch --cov-config=$OWLET_COVERAGERC_FILE ./tests"
alias owlet_test_unit="python -m pytest --cov=./ --cov-branch --cov-config=$OWLET_COVERAGERC_FILE ./tests/unit"

eval "$(pyenv init -)"
pyenv virtualenvwrapper_lazy

function getfbtoken () {
    token=$(http post https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword\?key\=$OWLET_FIREBASE_KEY "Content-Type: application/json" email=$OWLET_ACCOUNT_EMAIL password=$OWLET_ACCOUNT_PASSWORD returnSecureToken=True)
    echo $token | jq
    echo $token | jq -r .idToken | tr -d '[:space:]' | pbcopy
    echo "Token copied to your clipboard."
    FB_TOKEN=$(echo $token | jq -r .idToken | tr -d '[:space:]')
}
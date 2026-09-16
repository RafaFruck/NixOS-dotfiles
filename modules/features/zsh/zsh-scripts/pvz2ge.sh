#!/usr/bin/env zsh

# 1. Inicia ou cria o container do Docker
if [ "$(docker ps -aq -f name=pvzge)" ]; then
    docker start pvzge
else
    docker run --name pvzge -d -p 8080:80 gaozih/pvzge:latest
fi

# 2. Aguarda o servidor local carregar
sleep 5

# 3. Define um caminho de perfil estritamente isolado na pasta temporária
GAME_PROFILE="$HOME/.firefox-pvz2-game"
mkdir -p "$GAME_PROFILE"

# 4. Injeta os overrides direto no arquivo de configuração do perfil antes de ligar
# browser.display.use_document_fonts = 1 -> Corrige o layout desalinhado das fontes
# toolkit.startup.max_resumed_crashes = -1 -> Impede telas de erro em fechamentos brutos
echo 'user_pref("browser.display.use_document_fonts", 1);' > "$GAME_PROFILE/prefs.js"
echo 'user_pref("toolkit.startup.max_resumed_crashes", -1);' >> "$GAME_PROFILE/prefs.js"

# 5. Remove qualquer trava fantasma que possa ter restado de sessões anteriores
rm -f "$GAME_PROFILE/.parentlock"
rm -f "$GAME_PROFILE/lock"

# 6. Abre o Firefox nativo do seu sistema em Modo Isolado Total
# --no-remote: Permite abrir o jogo mesmo se você estiver navegando na internet no Firefox principal
# --kiosk: Abre em tela cheia real ocultando a barra de navegação superior
firefox --no-remote --profile "$GAME_PROFILE" --kiosk http://localhost:8080

# 7. Encerra o container do Docker assim que você fechar a janela do jogo
docker stop pvzge


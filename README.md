# APIs Divertidas em Flutter 🐶⚡👽

Aplicativo Flutter desenvolvido para a atividade prática de **Desenvolvimento para Dispositivos Móveis I — APIs Divertidas em Flutter**.

O objetivo é consumir **três APIs REST públicas** em telas independentes, interpretar respostas JSON, tratar carregamento e erros e oferecer interatividade. A implementação inclui os **10 exercícios** do enunciado (básicos, médios e desafios).

## Funcionalidades

| Tela | Funcionalidades |
| --- | --- |
| 🐶 **Galeria de cães** | Sorteio de fotos pela Dog CEO, título e estilo personalizados, frase acima da imagem, contador de fotos bem-sucedidas, seleção entre quatro raças com `ChoiceChip`/`Wrap`, nova foto por raça. |
| ⚡ **Pokédex** | Busca por nome ou ID via PokéAPI, foto, ID em `Card`, altura em metros, peso em kg, tipos em `Chip`/`Wrap`, Pokémon aleatório de 1 a 151, carregamento, validação e erro. |
| 👽 **Personagens** | Listagem pela Rick and Morty API com `ListView.builder`, `Card`, avatar, nome e status; detalhe com passagem de objeto, gênero e localização; filtro todos/vivos/mortos; paginação anterior/próxima; favoritos persistidos em `shared_preferences`. |

## Tecnologias

- **Flutter + Dart** (Material 3)
- **`http`** para as chamadas GET
- **`shared_preferences`** para armazenar IDs de favoritos
- `Future`, `async`/`await`, `setState`, `Navigator`, models com `fromJson`, `ListView.builder`

## Como executar (Windows / Android Studio ou VS Code)

1. Instale [Flutter](https://docs.flutter.dev/get-started/install), configure Android Studio/VS Code e verifique com `flutter doctor`.
2. Baixe o ZIP do repositório e **extraia os arquivos**, ou clone o repositório.
3. Abra a pasta `apis_divertidas_flutter` no VS Code ou no terminal.
4. **Na primeira execução**, rode os comandos abaixo para que o Flutter complete os arquivos de plataforma e instale as dependências:

   ```bash
   flutter create --project-name apis_divertidas_flutter --platforms=android,web .
   flutter pub get
   flutter run
   ```

   No Windows, você também pode clicar duas vezes em **`preparar_e_executar.bat`** para executar esses comandos automaticamente.

5. Escolha o emulador Android (recomendado) ou dispositivo disponível quando solicitado.

> **Nota:** os arquivos Dart e as telas do aplicativo já estão implementados. O comando `flutter create .` completa os arquivos gerados automaticamente pelo SDK Flutter (como o wrapper do Gradle), sem precisar escrever código. O projeto também contém configuração Android e Web. Para executar no Chrome, selecione o dispositivo Chrome em `flutter run -d chrome`; APIs externas no navegador dependem das regras de CORS de cada serviço.

### Testes e verificação

```bash
flutter analyze
flutter test
flutter run
```

A pasta `.github/workflows/` inclui GitHub Actions que executa análise estática, testes e build web a cada push.

## Estrutura do projeto

```text
apis_divertidas_flutter/
├── lib/
│   ├── main.dart
│   ├── modelos/
│   │   ├── personagem.dart
│   │   └── pokemon.dart
│   ├── servicos/
│   │   ├── api_service.dart
│   │   └── favoritos_service.dart
│   ├── telas/
│   │   ├── tela_caes.dart
│   │   ├── tela_pokedex.dart
│   │   ├── tela_personagens.dart
│   │   └── detalhe_personagem.dart
│   └── widgets/
│       └── componentes.dart
├── test/
├── web/
├── android/
├── .github/workflows/flutter.yml
├── pubspec.yaml
└── README.md
```

## Checklist dos 10 exercícios

- [x] **1. Personalize:** título, cor de fundo, texto do botão e frase acima da imagem na Galeria de Cães.
- [x] **2. Contador:** incrementa com `setState` após cada foto sorteada com sucesso.
- [x] **3. Escolha a raça:** 4 `ChoiceChip` em `Wrap`, altera o endpoint para a raça escolhida.
- [x] **4. ID e Card:** ID Pokémon exibido no `Card` de resultados.
- [x] **5. Pokémon aleatório:** botão usa `Random().nextInt(151) + 1`.
- [x] **6. Tipos:** tipos vindos do JSON apresentados em `Chip` dentro de `Wrap`.
- [x] **7. Mais dados no detalhe:** gênero (`gender`) e localização (`location.name`).
- [x] **8. Filtro por status:** todos, vivos e mortos consultados na API, com reinício da paginação.
- [x] **9. Próxima página:** navegação anterior e próxima respeitando `info.pages`.
- [x] **10. Favorito que não some:** botão de estrela na lista/detalhe, salva IDs de personagens no armazenamento local e atualiza ao retornar.

## APIs utilizadas

- [Dog CEO](https://dog.ceo/dog-api/): `https://dog.ceo/api/breeds/image/random` e `https://dog.ceo/api/breed/{raca}/images/random`
- [PokéAPI](https://pokeapi.co/docs/v2): `https://pokeapi.co/api/v2/pokemon/{nome-ou-id}`
- [Rick and Morty API](https://rickandmortyapi.com/documentation): `https://rickandmortyapi.com/api/character/?page={numero}&status={filtro}`

Todas as APIs exigem conexão com a internet. A permissão `INTERNET` está declarada no `AndroidManifest.xml`.

## Entrega no GitHub

1. Crie um repositório **público** no [GitHub](https://github.com/new) com o nome `apis-divertidas-flutter`.
2. Clique em **uploading an existing file** ou **Add file → Upload files**.
3. **Extraia o ZIP** e envie **o conteúdo interno da pasta**, incluindo `lib`, `test`, `android`, `web`, `pubspec.yaml` e `README.md`. Não envie o MP4 da aula.
4. Clique em **Commit changes**.
5. Copie o link do seu repositório, no formato `https://github.com/SEU-USUARIO/apis-divertidas-flutter`, e encaminhe à professora.

> Se for enviar pelo navegador, a interface pode não mostrar pastas ocultas no seletor de arquivos. A pasta `.github` contém a automação opcional, mas o aplicativo funciona mesmo que essa pasta não seja enviada. Para enviar tudo, pode usar Git pelo terminal:
>
> ```bash
> git init
> git add .
> git commit -m "Entrega: APIs Divertidas em Flutter"
> git branch -M main
> git remote add origin https://github.com/SEU-USUARIO/apis-divertidas-flutter.git
> git push -u origin main
> ```

## Observação de testes

Foram incluídos testes automatizados de modelos e de requisições mockadas. Como o projeto foi montado fora de uma instalação local do Flutter, **não foi possível executar `flutter analyze`, `flutter test` ou o emulador neste ambiente**; verifique esses comandos localmente ou consulte o resultado do GitHub Actions após publicar.

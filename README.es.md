[English](README.md) | [한국어](README.ko.md) | [中文](README.zh.md) | [日本語](README.ja.md) | Español

# git-teacher

<p align="center">
  <img src="assets/git-teacher-hero-01.png" alt="git-teacher" width="320">
</p>

> **Git y GitHub para quienes nunca quisieron aprender Git.**

No necesitas memorizar comandos. No necesitas saber qué es un «hash de commit». Si alguna vez has usado Google Drive, ya entiendes el 80 % de Git — solo que todavía no lo sabes.

[Inicio rápido](#inicio-rápido) • [¿Por qué git-teacher?](#por-qué-git-teacher) • [Cómo funciona](#cómo-funciona) • [Funciones](#funciones) • [Requisitos](#requisitos)

---

## Inicio rápido

### 1. Añade el marketplace (solo una vez)

```
/plugin marketplace add https://github.com/fivetaku/gptaku_plugins.git
```

### 2. Instala el plugin

```
/plugin install git-teacher
```

### 3. Reinicia Claude Code

Es necesario reiniciar para que el plugin se cargue.

### 4. Inicia la configuración

```
/git-teacher 시작
```

O simplemente di: `"깃 시작해줘"` (empieza con Git) — el plugin entiende lenguaje natural.

### 5. Sigue el flujo de 5 pasos

```
Pasos 1 + 2: Configuración   → instala las herramientas, crea tu carpeta de proyecto (una vez)
Paso 3: Guardar              → "저장해줘"   (haz commit de tus cambios)
Paso 4: Subir                → "올려줘"    (haz push a GitHub)
Paso 5: Pedir revisión       → "검토 요청해줘"  (abre un pull request)
```

---

## ¿Por qué git-teacher?

- **Sin memorizar comandos** — di lo que quieres hacer con tus propias palabras (en coreano) y el plugin se encarga del resto
- **Explicaciones basadas en analogías** — cada concepto se explica con Google Drive, Dropbox o iCloud, no con jerga de desarrolladores
- **Se salta lo que ya hiciste** — la configuración detecta tu estado actual y solo ejecuta los pasos que realmente necesitas
- **Traduce la salida de Git** — en lugar de `fatal: not a git repository`, recibes «이 폴더는 Git 프로젝트 폴더가 아니에요» (esta carpeta no es un proyecto de Git)
- **Se ocupa de lo difícil** — conflictos de merge, detached HEAD, stash — explicados en lenguaje llano y con opciones claras

---

## Cómo funciona

Git tiene una diferencia clave respecto a Google Drive: **nada se sincroniza automáticamente**. Cada guardado y cada subida es un paso manual. Una vez que sabes eso, el resto viene solo.

```
Editas un archivo
       │
       ▼
  Guardar (Commit)           ← "저장해줘"
  Empaqueta tus cambios
  Todavía solo en tu máquina
       │
       ▼
  Subir (Push)               ← "올려줘"
  Lo envía a la nube de GitHub
  Ahora otros pueden verlo
       │
       ▼
  Pedir revisión (PR)        ← "검토 요청해줘"
  «Equipo, echadle un vistazo»
  Como el modo sugerencias de Google Docs
```

### La comparación con Google Drive

| Google Drive | Git | Diferencia clave |
|---|---|---|
| Instalas la app | Instalas Git + GitHub CLI | Igual — necesitas una app para empezar |
| Inicias sesión con tu cuenta de Google | Conectas tu cuenta de GitHub | Igual — necesitas una cuenta para la nube |
| Creas una carpeta compartida | Creas un repositorio | Igual — una carpeta para tus archivos |
| Los archivos se sincronizan solos | **Los archivos NO se sincronizan solos** | **Esta es la clave** |
| Modo «sugerir cambios» | Pull Request | Parecido — «esto es lo que cambié, revísalo» |

> Lo más importante que debes recordar: Google Drive se sincroniza solo. Git no. Tienes que guardar (commit) y subir (push) manualmente. Si lo olvidas, tu trabajo se queda solo en tu máquina.

---

## Funciones

### Comandos

| Comando | Qué hace |
|---|---|
| `/git-teacher` | Abre un menú para elegir qué quieres hacer |
| `/git-teacher 시작` | Configuración: instala herramientas + crea la carpeta de proyecto |
| `/git-teacher 상태` | Estado: ¿qué cambió desde tu último guardado? |
| `/git-teacher 저장` | Guardar: haz commit de tus cambios en local |
| `/git-teacher 올리기` | Subir: haz push de los commits a GitHub |
| `/git-teacher 검토` | Revisión: abre un pull request |
| `/git-teacher 도움말` | Ayuda: explica cualquier término de Git con analogías |

### Disparadores en lenguaje natural

No hace falta usar comandos de barra. Estas frases también funcionan:

| Lo que quieres | Di esto |
|---|---|
| Configuración inicial | "깃 시작해줘", "깃 설정", "처음이에요" |
| Ver el estado actual | "지금 어떤 상태?", "뭐가 바뀌었어?" |
| Guardar cambios (Commit) | "저장해줘", "커밋", "세이브" |
| Subir a GitHub (Push) | "올려줘", "푸시", "업로드" |
| Pedir revisión (PR) | "PR 만들어줘", "검토 요청해줘" |
| Preguntar por un término | "commit이 뭐야?", "push랑 commit 차이" |

### Skills

| Skill | Fase | Descripción |
|---|---|---|
| `git-teacher-setup` | 1–2 | Instala Git, conecta GitHub, crea la carpeta de proyecto |
| `git-teacher-status` | — | Traduce `git status` a lenguaje llano |
| `git-teacher-save` | 3 | Hace commit de los cambios con un resumen en lenguaje natural |
| `git-teacher-upload` | 4 | Hace push de los commits a GitHub |
| `git-teacher-review` | 5 | Crea un pull request |
| `git-teacher-help` | — | Glosario de términos + FAQ con analogías de la nube |

### Sistema de ayuda

El skill `git-teacher-help` responde a preguntas como:

- "commit이 뭐야?" (¿qué es un commit?) → resumen de una línea + analogía con Google Drive
- "push랑 commit 차이?" (¿diferencia entre push y commit?) → tabla comparativa
- "Git 작업 흐름이 어떻게 돼?" (¿cómo es el flujo de trabajo de Git?) → diagrama del flujo completo en lenguaje llano
- "fatal: not a git repository 이게 뭐야?" (¿qué significa esto?) → traducción + qué hacer a continuación

---

## Requisitos

- CLI de [Claude Code](https://docs.anthropic.com/claude-code)
- Suscripción Claude Max/Pro o una clave de API de Claude compatible

Sin dependencias adicionales. Sin npm install. Sin paso de build.

---

## Licencia

MIT — [fivetaku](https://github.com/fivetaku)

---

<div align="center">

**Git no es difícil. Solo necesitaba un mejor profesor.**

</div>

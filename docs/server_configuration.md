# Owl - Always-on Perceptive AI

[<< Home](../README.md)

## Server Configuration

The minimal steps necessary to configure the server are listed here.

### 1. Create config.yaml in Project Root Directory

Copy `sample_config.yaml` to the root of the source tree, from where the server is run, and rename
it to `config.yaml`. When running the server, this customized configuration file can be specified by
adding the `--config=config.yaml` command line option.

Next, open `config.yaml` and configure it appropriately.

### 2. Configure User

- Set your name so the AI knows who you are and choose a secret token (a string of any length) to prevent others from accessing conversations on your server. The token will also be entered into display client applications that access the server.

```
user:
  name: "Kramer"
  client_token: 123XYZ_this_is_my_secret_token
```

### 3. Configure LLM

- [LiteLLM](https://litellm.ai/) is used as an interface to LLMs for summarization, etc. The `llm` section allows local (e.g., Ollama) or remote (e.g., OpenAI) LLMs to be specified.
- OpenAI's GPT-4 is the easiest to get up and running. [Sign up for a developer account](https://platform.openai.com/), deposit some funds for usage (we recommend beginning with ~$10), and obtain an API key. Paste that into `config.yaml`.

```
llm:
  model: gpt-4-1106-preview
  api_base_url:
  api_key: sk-a1BCDEfGhI2JKlMNOPqRS3TuvwXY4ZaBCdEFghIJK5lmnO67
```

### 4. Select Providers for Speech-to-Text Transcription

- Asynchronous transcription is used once a conversation has been detected and completed to transcribe the entire conversation.
- Streaming transcription is used for real-time transcription of speech to support assistant-in-the-loop use cases. It is only used with streaming captures but not chunked uploads.
- Deepgram is recommended for getting up and running quickly but Whisper may also be used locally if your server is capable of handling it.

```
streaming_transcription:
  provider: "deepgram"

async_transcription:
  provider: "deepgram"
```

### 5. Obtain a Deepgram API Key

- Deepgram is an online transcription service that features speaker diarization and other features. It is easy to set up, inexpensive, and new accounts are provided an ample amount of credits that should last for a long time. [Sign up for an account](https://deepgram.com/), obtain an API key, and paste it into `config.yaml`.

```
deepgram:
  api_key: "a1b2cd34ef56g7hi9012j34klmn56789012o34p5"
  model: "nova-2"
  language: "en-US"
```

- The `nova-2` model is recommended. Be aware that it has a limited number of supported languages.
- Users requiring absolute control and privacy may elect to switch away from Deepgram but it is nevertheless the easiest way to get up and running initially.

### 6. Obtain a Hugging Face API Token for Whisper and Speaker Identification Models

- Register a [Hugging Face](https://huggingface.co) account and obtain a token (these are found under "Access Tokens" in "Settings"). 
- Owl uses PyAnnote for diarization. Please visit the following Hugging Face model pages and accept the terms for each:
  - [PyAnnote Segmentation Model](https://huggingface.co/pyannote/segmentation)
  - [PyAnnote Speaker Diarization Model](https://huggingface.co/pyannote/speaker-diarization)
- The Hugging Face token is needed for asynchronous Whisper transcription (if enabled) and the SpeechBrain speaker verification model. For example:

```
async_whisper:
  host: "127.0.0.1"
  port: 8010
  hf_token: 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
  device: cpu
  compute_type: int8
  batch_size: 16
  model: tiny
  verification_threshold: 0.1
  verification_model_source: speechbrain/spkrec-ecapa-voxceleb
  verification_model_savedir: pretrained_models/spkrec-ecapa-voxceleb
```

### 7. Run the Server

- Run the server as per the [setup instructions](../README.md#server-setup) with `--config=config.yaml`.

### 8. Environment Variables

Configuration file keys can be overridden with environment variables. The format is `OWL_SECTION_KEY_NAME`. For example, the Hugging Face token under the `async_whisper` section can be set in e.g. bash with: 

```
export OWL_ASYNC_WHISPER_HF_TOKEN=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
```

[<< Home](../README.md)
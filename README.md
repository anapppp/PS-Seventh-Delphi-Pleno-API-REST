# Processo seletivo da Seventh para a vaga de desenvolvedor Delphi Pleno.

Desenvolvimentod e uma API-REST em Delphi para o contexto de videomonitoramento usando o framework Horse.


## URIs das operações:

 - Criar um novo servidor

```/api/server ```

- Remover um servidor existente

```/api/servers/{serverId}```

- Recuperar um servidor existente

```/api/servers/{serverId}```

- Checar disponibilidade de um servidor

```/api/servers/available/{serverId}```

- Listar todos os servidores

```/api/servers```

- Adicionar um novo vídeo à um servidor

```/api/servers/{serverId}/videos```

- Remover um vídeo existente

```/api/servers/{serverId}/videos/{videoId}```

- Recuperar dados cadastrais de um vídeo

```/api/servers/{serverId}/videos/{videoId}```

- Download do conteúdo binário de um vídeo

```/api/servers/{serverId}/videos/{videoId}/binary```

- Listar todos os vídeos de um servidor

```/api/servers/{serverId}/videos```

- Reciclar vídeos antigos

```/api/recycler/process/{days}```

```/api/recycler/status```

## HashLoad

Usei o Boss como gerenciador de dependências

https://github.com/HashLoad
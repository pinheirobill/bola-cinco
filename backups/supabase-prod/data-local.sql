SET session_replication_role = replica;

--
-- PostgreSQL database dump
--

-- \restrict nH34CfzDYIyuBRiq6IOWbfF9h5dXx1r4Prc8HvZqMBC36BvZ5KJszOhXqK9Mpwh

-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Data for Name: active_storage_blobs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."active_storage_blobs" ("id", "key", "filename", "content_type", "metadata", "service_name", "byte_size", "checksum", "created_at") FROM stdin;
7	u6dkaejtsogr5rl0jkuxi7x8jqff	logo-club-pinheiros.jpeg	image/jpeg	{"identified":true}	local	151765	SAsrpm/L/pq1XiWo/76Hiw==	2026-09-17 18:41:18.334324
\.


--
-- Data for Name: active_storage_attachments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."active_storage_attachments" ("id", "name", "record_type", "record_id", "blob_id", "created_at") FROM stdin;
7	logo	Championship	6	7	2026-09-17 18:41:18.425963
\.


--
-- Data for Name: active_storage_variant_records; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."active_storage_variant_records" ("id", "blob_id", "variation_digest") FROM stdin;
\.


--
-- Data for Name: ar_internal_metadata; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."ar_internal_metadata" ("key", "value", "created_at", "updated_at") FROM stdin;
environment	production	2026-09-04 16:08:31.795563	2026-09-04 16:08:31.795568
schema_sha1	b5f46584f52600de60b20111dc3ee99e7a292dfa	2026-09-04 16:08:32.028719	2026-09-04 16:48:19.084228
\.


--
-- Data for Name: championships; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."championships" ("id", "created_at", "end_date", "format", "modality", "name", "notes", "public_signup_visits_count", "registration_end", "registration_start", "rules", "scoring", "season", "slug", "source_id", "start_date", "status", "updated_at") FROM stdin;
6	2026-09-10 17:01:44.131463	2026-09-19	{"teamCount":"44","groupCount":"11"}	tranca	12º TORNEIO DE TRANCA CLUBE PINHEIROS	FINALIDADE\nO 12º Torneio de Tranca do CLUBE PINHEIROS tem como finalidade principal, promover o congraçamento entre associados, através de um evento esportivo-social.\nDESCRIÇÃO\nO jogo é jogado com 4 participantes formando duas duplas situadas em posições alternadas.\nJogadores - 4.\nBaralhos - dois de 52 cartas.\nDistribuição - onze cartas para cada participante e dois mortos de 11 cartas.\nObjetivo - Fazer mais pontos \n\nDAS INSCRIÇÕES\nAs inscrições poderão ser realizadas individualmente ou em duplas, e serão realizadas na Sala do Carteado ou na Central de atendimentos de 17 de agosto de 2026 a 07 de setembro de 2026. O torneio será realizado com no máximo 48 duplas.\nAos que se inscreverem individualmente (apenas associados), momentos antes do início do torneio, será realizado sorteio para definir as duplas. Coso o inscrito de forma individual não encontre um parceiro para jogar, o mesmo não participará do Torneio.\nApós definições das duplas, será realizado sorteio para definir os confrontos.\nSó poderão participar associados, devidamente em dia com Clube.\nÚNICO: A AUSÊNCIA, OU ATRASO DE UM OU DOIS PARTICIPANTES DA DUPLA, ACARRETARÁ A EXCLUSÃO DELA, DA ETAPA, NÃO SENDO PERMITIDAS TROCAS, OU SUBSTITUIÇÕES.\n\nFORMA DA DISPUTA\nO torneio será disputado com 48 duplas, em fases:\n1ª ETAPA – SÁBADO 12/09/2026 - As duplas presentes, serão distribuídas ANTECIPADAMENTE, em CHAVES DE 04 DUPLAS cada. \nJogarão entre sí, dentro da chave, classificando, para a 2ª ETAPA, as duplas que somarem o MAIOR NÚMERO DE VITÓRIAS (PONTOS GANHOS), ou seja as 1ª colocadas de cada chave mais as as duplas mais bem colocadas até atingir o número de 16 duplas.\nEm caso de empate, entre 02 (duas) duplas, numa mesma colocação, serão observados os seguintes critérios: a) Maior número de vitórias, b) Maior número de pontos, c) Maior Saldo de pontos d) sorteio.\n\n\nA FORMAÇÃO DAS CHAVES E FORMA DE CLASSIFICAÇÃO DEFINITIVA SERÁ INFORMADA, UM DIA ANTES DA DATA DE INÍCIO DOS JOGOS. A COORDENAÇÃO ORIENTARÁ AS DUPLAS PRESENTES SOBRE POSIÇÕES NAS MESAS DE JOGO.\nA COORDENAÇÃO SE RESERVA NO DIREITO DE ADEQUAR, OU ALTERAR A FORMA DE DISPUTA, EM CONSEQUÊNCIA DA QUANTIDADE DE DUPLAS PRESENTES.\nAs partidas serão de 3.000 pontos, ou, 45 MINUTOS NA 1ª, 2ª e 3ª RODADAS. Os pontos serão marcados em súmulas oferecidas pela organização, ao final de cada partida. As 16 (DEZESSEIS) duplas classificadas, estarão credenciadas para disputar as fases FINAIS, que acontece dia 19 de setembro de 2026.\nCaso a chave seja de 03 (três) duplas, por ausência do adversário, a coordenação colocará como W.O. e os pontos serão dados, fazendo uma média entre os pontos feitos e sofridos das outras duas partidas.\nIMPORTANTE: OS RESULTADOS E CLASSIFICAÇÃO SERÃO INFORMADAS NO INÍCIO DA SEMANA, SENDO QUE, TODAS AS DUPLAS REBERÃO COMUNICAÇÃO, INFORMANDO QUAIS FORAM AS 16 DUPLAS CLASSIFICADAS PARA 2ª ETAPA.\nETAPA FINAL – SÁBADO 19/09/2026\n1ª fase: As 16 (dezesseis) duplas classificadas serão distribuídas em 04(quatro) chaves de 04(quatro) duplas cada, classificando as 2(duas) mais bem colocadas de cada chave, para fase seguinte;\nEm caso de empate, entre 02 (duas) duplas, numa mesma colocação, serão observados os seguintes critérios: a) Maior nº de Vitórias, b) Maior número de pontos, c) Maior Saldo de pontos d) sorteio.\nQuartas de Final: As 08 (oito) duplas classificadas JOGARÃO DE FORMA ELIMINATÓRIA SIMPLES, classificando vencedoras, para SEMIFINAL. Ordem dos jogos\nQF01 – 1ª CHAVE 01 X 2ª CHAVE 04; QF02 – 1ª CHAVE B X 2ª CHAVE 03; QF03 – 1ª CHAVE 03 X 2ª CHAVE 02 E QF04 – 1ª CHAVE 04 X 2ª CHAVE 01.\nSemifinal – As 04(quatro) duplas classificadas nas quartas JOGARÃO DE FORMA ELIMINATÓRIA SIMPLES, os vencedores disputarão o título, enquanto as perdedoras disputarão o 3º lugar.\nFinais – As 02 (duas) duplas vencedoras das semifinais decidirão o título e as 02 (duas) duplas perdedoras disputarão o 3º lugar.\nIMPORTANTE: O CRITÉRIO PARA DESEMPATE, NAS QUARTAS, SEMIFINAIS, DISPUTA DE 3º LUGAR E FINAL, SERÁ NUMA RODADA EXTRA, OU SEJA, INICIAMOS UMA PARTIDA, E A DUPLA VENCEDORA  ESTARÁ CLASSIFICADA:\nIMPORTANTE: TODAS AS FASES DA 2ª ETAPA, DIA 19/09/26 SERÃO DISPUTADAS EM PARTIDAS DE 2.000 (DOIS MIL) PONTOS OU 30 MINUTOS.\n\n\nDAS REGRAS\nO carteador será escolhido por sorteio, e será jogador que tirar a carta mais alta do baralho, sendo ÀS menor e REI maior.\nSerão feitos 2(dois) mortos (11 cartas cada um), pelo competidor à esquerda daquele que irá distribuir as cartas\nSentido do jogo é anti-horário.\nO primeiro jogador a direita do carteador inicia o jogo, este jogador tem o direito de comprar 2(duas) cartas, desde que a primeira carta não sirva e não junte as cartas da mão.\nO 3 (três) vermelho: deverá ser trocada por outra carta, somente em sua vez de jogar no inicio da jogada.  \nCaso o jogador tenha comprado uma carta e tenha esquecido de trocar o 3 (três), vermelho, só poderá realizar a troca na próxima rodada. \nQuando for comprado no monte de cartas, deverá ser trocado no momento da compra. Caso a carta fique retida na mão do jogador, este perderá 100 pontos ao final da rodada (contagem de pontos). A carta deverá ser colocada ao lado da pessoa que irá baixar as cartas.\nO jogador só poderá trocar os 3 (três) vermelhos do seu morto caso haja cartas na mesa para comprar. Não havendo cartas suficientes, o jogo acaba e os 3 (três) vermelhos que sobrarem na mão do jogador serão contadas como cartas normais.\nO 3 (três) preto tranca as cartas da mesa. Cada 3 (três) preto que estiver na mão do jogador ao final da partida, perderá 100 pontos ao final da contagem.\nLavadeira somente de Ás, 4 (quatro) e Rei.\nA carta 2 (curinga), caso seja descartada no lixo de cartas poderá ser utilizada como curinga naturalmente, desde que, o adversário baixe pelo menos 2(duas) cartas, formando um novo jogo. O curinga não pode ser encaixado em cartas já baixadas na mesa.\nO jogador poderá pegar o morto mesmo não tendo uma canastra. O morto (caso, para comprar o morto, o jogador baixe todas as cartas e não tiver descarte “foi direto”, poderá baixar todas as cartas que estiverem no morto e descartar uma carta que não lhe servir. Se descartar para comprar o morto “não foi direto”, só poderá mexer nas cartas do morto na próxima jogada. Caso a dupla adversaria já tenha comprado o morto e bata antes da vez do jogador que acabou de comprar o morto, a sua dupla será penalizada com a perda de 100 pontos.)\nCaso as cartas do monte de compra tenham acabado e nenhuma dupla foi no morto, o jogo acaba, o morto não entra na mesa. Caso uma das duplas tenha ido no morto e as cartas do monte de compra acabem antes que essa dupla bata o jogo, o outro morto não entra no jogo e a dupla que não pegou o morto é penalizada com a perda de 100 pontos na contagem final.\nO jogo segue dentro das mesmas regras, porém, só poderá bater a partida o jogador da dupla que já tenha comprado o morto e tenha feito pelo menos uma canastra “suja ou limpa”.\nPara bater no final não será necessário ter uma canastra real, mas é preciso ter uma canastra.\n\nA Primeira Etapa. Todas as partidas iniciarão ao mesmo tempo, quando der os 45 minutos, o juiz irá anunciar que as duplas não poderão dar mais cartas. A partida acaba quando as cartas que estiverem nas mãos dos jogadores terminarem ou uma das duplas alcançar os 3.000 pontos.\nNa Segunda Etapa. Todas as partidas iniciarão ao mesmo tempo, quando der os 20 minutos, o juiz irá anunciar que as duplas não poderão dar mais cartas. A partida acaba quando as cartas que estiverem nas mãos dos jogadores terminarem ou uma das duplas alcançar os 2.000 pontos.\n\nDA CONTAGEM DOS PONTOS\nEncerrada a mão os pontos serão contados da seguinte forma:\nBatida: 100 pontos pela partida, para dupla que venceu.\nCanastra Limpa serão contados 200 pontos.\nCanastra suja serão contados 100 pontos.\n3 (três) vermelho baixado + 100 pontos positivos \n3 (três) vermelho não baixado - 100 pontos negativos \n(Caso a dupla não tenha canastra ou tenha ficado com algum 3 vermelho na mão, serão computados 100 pontos negativos por cada 3 vermelho, que deverão ser deduzidos da soma final).\nA dupla que não conseguir comprar o morto será penalizada com 100 pontos negativos.\nPara cada 3 (três) preto que estiver na mão do jogador ao final da partida, perderá 100 pontos ao final da soma.\nPara cada carta baixada na mesa, serão contados 10 pontos positivos, independente de formarem ou não canastras.\nAs cartas que não forem baixadas e ficarem na mão do jogador, serão deduzidos 10 pontos por cada carta da soma final. Elas deverão ser distribuídas em montes de 10 (dez) cartas, com a frente voltada para cima.\nOs pontos serão anotados em papel a parte e vencerá a dupla que primeiro somar 2.000 pontos, deverão ser jogadas quantas mãos forem necessárias para se atingir o total estipulado.\nPREMIAÇÃO\nSerão oferecidos prêmios as 04 DUPLAS mais bem classificadas, da etapa final que acontece dia 19 de setembro de 2026, \nIMPORTANTE: 1ª ETAPA NÃO HAVERÁ PREMIAÇÃO\n\n\nDISPOSIÇÕES FINAIS\nA forma de disputa poderá ser alterada em função do número de duplas participantes;\nÉ proibido cantar o jogo, para o parceiro ou falar durante a partida;\nCada dupla fiscalizará na contagem de pontos, sendo que haverá 04(quatro) fiscais da coordenação para apoio na contagem;\nAs duplas que porventura infringirem este regulamento serão desclassificadas;\nFicará a cargo do quarteto de árbitros esclarecer as regras, e tomar qualquer decisão sobre possíveis infrações que ocorram durante transcorrer do evento;\nOs organizadores TERÃO PLENO PODERES, para decidir, ou alterar qualquer artigo, caso seja necessário, para o bem da disputa.\nCasas omissos serão resolvidos pelos organizadores.\nBoa sorte a todos,\nCoordenação,\n	0	2026-08-31	2026-08-01	{"registration":{"max_athletes_per_team":"2","max_staff_members_per_team":"3","team_signups":{"enabled":"1"}}}	{"win":"1","draw":"0","loss":"0","wo":"0","woScore":"0","qualifiedPerGroup":"1"}	2026	12-torneio-de-tranca-clube-pinheiros-2026	championship-51541f90	2026-09-12	em_andamento	2026-09-17 18:41:18.487241
\.


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."categories" ("id", "championship_id", "created_at", "gender", "max_athletes", "max_birth_year", "min_birth_year", "name", "position", "source_id", "updated_at") FROM stdin;
11	6	2026-09-10 17:02:54.058856	\N	\N	\N	\N	12º TORNEIO DE TRANCA CLUBE PINHEIROS	\N	category-tranca-championship-51541f90	2026-09-10 17:02:54.058856
\.


--
-- Data for Name: entities; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."entities" ("id", "city", "created_at", "email", "name", "notes", "phone", "responsible", "source_id", "updated_at", "whatsapp") FROM stdin;
106	\N	2026-09-10 17:05:30.650989	\N	Luiza Bianco Checchia / Henrique Tafarelo	\N	\N	\N	tranca-import-entity-6-4d6b5c90c0e31808bc62b0e196d480ecca780a095826fe8526797337deb2dcd5	2026-09-10 17:05:30.650989	\N
107	\N	2026-09-10 17:05:32.463193	\N	Cleid Fernandes / Maria Helena Serzedo	\N	\N	\N	tranca-import-entity-6-cebe7c5dd2775f6a1846b6a6ba48dc34411f5caff8baeb2593b1a8d464137a77	2026-09-10 17:05:32.463193	\N
108	\N	2026-09-10 17:05:33.777908	\N	Antonio Sérgio Fernandes / Carlos Alberto Pedreschi	\N	\N	\N	tranca-import-entity-6-086f12b12f621d0712ec8485e4f1adeef6193114829a990beb8a7dd5d9f5350a	2026-09-10 17:05:33.777908	\N
109	\N	2026-09-10 17:05:35.077972	\N	Rúbia Mara Cineze / Amélia Maria Orsini Platzeck	\N	\N	\N	tranca-import-entity-6-953003ae4b2222f129ce542f8aa873b6b7fd0df76cd047cf43e7d32fd1aafe8e	2026-09-10 17:05:35.077972	\N
110	\N	2026-09-10 17:05:36.372	\N	Isis de Aguiar Vallim Lerosa / Dirce Pimentel Levy	\N	\N	\N	tranca-import-entity-6-d68d9c5a2f7708af7f1db1bf25da71c3317d4940df70dc2346f6131c8acf40d6	2026-09-10 17:05:36.372	\N
111	\N	2026-09-10 17:05:37.672452	\N	Lais Baptista Silva / Tatiana Baptista Silva Zuccari	\N	\N	\N	tranca-import-entity-6-a72bea26a8cf9b010c7d53030aa401e42f1c99bd23fcb0cc8a7e142145109323	2026-09-10 17:05:37.672452	\N
112	\N	2026-09-10 17:05:38.983899	\N	Elzibieta Xenia Krygler Catani / Maria Antonieta Vieira Moss	\N	\N	\N	tranca-import-entity-6-e6d168cd05f5ef8a9ad565b10f5fb51a25556062f232c2b82dc0263b048d581a	2026-09-10 17:05:38.983899	\N
113	\N	2026-09-10 17:05:40.307512	\N	Catharina Parodi / Celia Campagno Cyrino Pereira	\N	\N	\N	tranca-import-entity-6-1a35c59ba71e1135ebe98c5e3890d497273e8b1e2e3311a88a02b4874f5d5cfc	2026-09-10 17:05:40.307512	\N
114	\N	2026-09-10 17:05:41.6113	\N	Laurinda Rocha Tafarello / Virginia de Barros Basto	\N	\N	\N	tranca-import-entity-6-40e827a68885f3c5bad3cd2567357517014466f93bfd6fd8c194849291292ac6	2026-09-10 17:05:41.6113	\N
115	\N	2026-09-10 17:05:42.903904	\N	Marco Antonio Gomes / Rita Rocchiccioli	\N	\N	\N	tranca-import-entity-6-65e64c1e3b7c224a93694744f543d72481bd11aa55aea2892fdeffe76a928558	2026-09-10 17:05:42.903904	\N
116	\N	2026-09-10 17:05:44.192256	\N	Marilena Graziano de A. Barros / Anna Mª Matarazzo Trunkl	\N	\N	\N	tranca-import-entity-6-04b0e1fb0bf08b6bf41c7c7431e2b87b40cbd0f5f84883a2efb5aaa4faaa696b	2026-09-10 17:05:44.192256	\N
117	\N	2026-09-10 17:05:45.508612	\N	Neuza da Rocha F. Mendes / Neide Neli Richter	\N	\N	\N	tranca-import-entity-6-7fc7039e8bc6dafe15e74a8d6e5197b8e7c33e1766cad8951be9d358731cfb6e	2026-09-10 17:05:45.508612	\N
118	\N	2026-09-10 17:05:46.808587	\N	Maria Teresa Lima da Costa / Francesly Sanzi	\N	\N	\N	tranca-import-entity-6-56d6211102e63e600b608474429b9dc0456326d7919218dbdced51eef66dbf83	2026-09-10 17:05:46.808587	\N
119	\N	2026-09-10 17:05:48.125133	\N	Eloísa Maria Amaro / Conceição Pastore de Barros Camargo	\N	\N	\N	tranca-import-entity-6-02a7cb629b599f1fbc647756033f9798be59d86148a5bb2d34826f5e5b5be78d	2026-09-10 17:05:48.125133	\N
120	\N	2026-09-10 17:05:49.422982	\N	Neide Maria de Carvalho / Sérgio Roberto Granieri	\N	\N	\N	tranca-import-entity-6-e86e94240cbe912a60e96e86cc3327f8744cf6542a90fd46578088ba5f1fe7ad	2026-09-10 17:05:49.422982	\N
121	\N	2026-09-10 17:05:50.712999	\N	Vera Regina F. Castro Brandão / Stella Maria de Faria Arduino	\N	\N	\N	tranca-import-entity-6-eab4be73a60d5bd3681288517dc85ac227eaf5537c8fd2012fe032fe29f01407	2026-09-10 17:05:50.712999	\N
122	\N	2026-09-10 17:05:52.003151	\N	Claudia Pirani Xande / Beatriz Helena Tess	\N	\N	\N	tranca-import-entity-6-282d86dcc0eaa955711b45b02849a077816d3b828d5078750d55a979f54f4b43	2026-09-10 17:05:52.003151	\N
123	\N	2026-09-10 17:05:53.290166	\N	Rosana Campi Sophia / Eduardo Luiz Sophia	\N	\N	\N	tranca-import-entity-6-35198179812da002f5d118a55c359e35bdd20c93fa976df1d911e889e0cdb8c7	2026-09-10 17:05:53.290166	\N
124	\N	2026-09-10 17:05:54.579593	\N	Rosa Maria Barone Russo / Claudia M. G. L. Gregorio	\N	\N	\N	tranca-import-entity-6-3feab4c9791be2242887ff8ec2abef46c1e5fb5a0c6eb898f992cdde5725f916	2026-09-10 17:05:54.579593	\N
125	\N	2026-09-10 17:05:55.866703	\N	Eliane Avancini (Lili) / Beatriz Andrade Basile	\N	\N	\N	tranca-import-entity-6-465abe9757e2cd5529861cb14ddb16747721040847b6ea9f9a1de5f801ad1794	2026-09-10 17:05:55.866703	\N
126	\N	2026-09-10 17:05:57.157209	\N	Maria Clara Toledo Fontes / Alice G. Saraiva Dinelli	\N	\N	\N	tranca-import-entity-6-55e92b5be52702edf59bfd4e9f421275e6d0f81a7c0080ade4b81fdc39b6ebaa	2026-09-10 17:05:57.157209	\N
127	\N	2026-09-10 17:05:58.443006	\N	Sonia Regina Maxemiuk Augusto / Anna Mª Bernardini Della	\N	\N	\N	tranca-import-entity-6-5c98436f3b80c28c08ef20ec781384b79fdb46fd68d77f06c0c87f9277bb4473	2026-09-10 17:05:58.443006	\N
128	\N	2026-09-10 17:05:59.749244	\N	Monica de Baptista Medina / Paula Cristina Moreira Pires	\N	\N	\N	tranca-import-entity-6-a935db4d5b342a08f04d820dcf9d243d35a250d2ddef11227a3013af9aedf4b6	2026-09-10 17:05:59.749244	\N
129	\N	2026-09-10 17:06:01.043861	\N	Dárcio M. Falcão / Marlene Martiniano de Azevedo	\N	\N	\N	tranca-import-entity-6-06aa32f7aece548e64e5b10b8b4107ed708d638999812f7b71789094056b0347	2026-09-10 17:06:01.043861	\N
130	\N	2026-09-10 17:06:02.336546	\N	Maria Cecília Loviat / Andiara Maria Roessle Guimarães	\N	\N	\N	tranca-import-entity-6-6c755f7a8e27349d6c5869446e8eb3fc4097d5375aeebab61add080c1160f916	2026-09-10 17:06:02.336546	\N
131	\N	2026-09-10 17:06:03.624014	\N	Eucy Maria Malta Ferreira Cintra de Barros / Marilia Rahal Zorob de Paula Assis	\N	\N	\N	tranca-import-entity-6-2dfb2be94c2f296937bad07d72def1bba88cf0972007054903d12a140ceb217f	2026-09-10 17:06:03.624014	\N
132	\N	2026-09-10 17:06:04.912851	\N	Luís Roberto Leonel de Arruda / Leila Baptista Silva Zuccari	\N	\N	\N	tranca-import-entity-6-b7b38d4add6fca4e1722285c078deb6efa27ca8c3234453655e5629bbc96c723	2026-09-10 17:06:04.912851	\N
133	\N	2026-09-10 17:06:06.202231	\N	Erece Assaf Ricotti / Nilde C. Rainho	\N	\N	\N	tranca-import-entity-6-37df6c14f261a87899f751653bcf365357a3ed600734f0a965bd05ffa113e106	2026-09-10 17:06:06.202231	\N
134	\N	2026-09-10 17:06:07.488982	\N	Fabio Andrade Reinbold / Silvia Moll Reinbold	\N	\N	\N	tranca-import-entity-6-17516303a91fe00dd001e26aa8b7b213b9814c248c84d56645cc53cbd290727c	2026-09-10 17:06:07.488982	\N
135	\N	2026-09-10 17:06:08.77896	\N	Luiz Fernando G. de Mello Faro / Fernando Murat de M. Faro	\N	\N	\N	tranca-import-entity-6-a7f0e41cde2d83e1c8f68623d22a47228892a3567a9159c7c9aa1be1ac1f251a	2026-09-10 17:06:08.77896	\N
136	\N	2026-09-10 17:06:10.068874	\N	Leila Bacelar Chicca / Carolina Bacelar Chicca	\N	\N	\N	tranca-import-entity-6-833584ca6be32a4794fce0944925f265b84b092cfaec2a9eed060338cfa4e5bb	2026-09-10 17:06:10.068874	\N
137	\N	2026-09-10 17:06:11.358117	\N	Marcia Regina Bacchin / Gizelle Autran	\N	\N	\N	tranca-import-entity-6-fa4c8d82f9804a7e6528155e9e3909a142882be3cab2a8a9e7eed1bd2158d8d6	2026-09-10 17:06:11.358117	\N
138	\N	2026-09-10 17:06:12.647172	\N	Arnaldo Osse Filho / Glaucia Langbeck Osse	\N	\N	\N	tranca-import-entity-6-968089c4b3582fcd1a34c0241995d34362450eda71ee4430434d8a9d9d71cfe2	2026-09-10 17:06:12.647172	\N
139	\N	2026-09-10 17:06:13.938308	\N	João Gilberto Pacces / Maria de Lourdes Dal Buono	\N	\N	\N	tranca-import-entity-6-5be0ab3c3f394a96389d1e9ca3860d7d22d8be24dcfc5883dcafac5c3ddca5d8	2026-09-10 17:06:13.938308	\N
140	\N	2026-09-10 17:06:15.226032	\N	Adriana Braga / Cleusa B Costa	\N	\N	\N	tranca-import-entity-6-f1d797a31f9c2628777a72f4236c06d7213d21200a585e26b59e3174084ff49c	2026-09-10 17:06:15.226032	\N
141	\N	2026-09-10 17:06:16.535062	\N	Ana Cecilia F. de Sá Borrelli / Ivan Gonçalves Branco da Silva	\N	\N	\N	tranca-import-entity-6-4124b59fb2ba00dd8e161b7c1b13ce3d6329abc9d7f1083ec368ff80c25b5b0f	2026-09-10 17:06:16.535062	\N
142	\N	2026-09-10 17:06:17.822301	\N	Mario Montenegro Gasparini / Renata Chequer Machado	\N	\N	\N	tranca-import-entity-6-b7842b146675503a8f8cd5bd0bd65d61e6df8fdf05e9b370362882f69d87ce85	2026-09-10 17:06:17.822301	\N
143	\N	2026-09-10 17:06:19.114566	\N	Leon Majer / Marta Dubrez Pimenta Campos	\N	\N	\N	tranca-import-entity-6-5aaaf0483b8680af2030b4239d4faee3678a169564f983b087894f37293a1a0a	2026-09-10 17:06:19.114566	\N
144	\N	2026-09-10 17:06:20.402845	\N	Telma Magalhães Buckup / Anahi M. Bayma de Carvalho	\N	\N	\N	tranca-import-entity-6-19d86aaf88c8c8c0105d692861c29651e34c6aafc1d56240457f766d54610b4b	2026-09-10 17:06:20.402845	\N
145	\N	2026-09-10 17:06:21.69238	\N	Carlos Antonio Rossi Rosa / Marcelo Fernando Lopo Lima	\N	\N	\N	tranca-import-entity-6-05c3cc03a69d59c0c9a24b627974dbea1582f663a0fa465a54ee77fcf7ef2a2d	2026-09-10 17:06:21.69238	\N
146	\N	2026-09-10 17:06:22.983545	\N	Maria Lúcia Stape / Nilda Monteiro Calife	\N	\N	\N	tranca-import-entity-6-588428c037acc202ebe1fc374d11020da829a4a80bd7bda1ef3a9cab23f9cf0a	2026-09-10 17:06:22.983545	\N
147	\N	2026-09-10 17:06:24.272906	\N	Marilena Simões de Queiroz / Denise F. Pignalosa	\N	\N	\N	tranca-import-entity-6-f94ec956b73e0f767d3e8e43261e39aef3b63f7d41d6158bf377f82491d700e3	2026-09-10 17:06:24.272906	\N
148	\N	2026-09-10 17:09:08.205207	\N	Dupla 43	\N	\N	\N	entity-e81b00ad	2026-09-10 17:09:08.205207	\N
149	\N	2026-09-10 17:09:30.733769	\N	Dupla 44	\N	\N	\N	entity-94b4bc57	2026-09-10 17:09:30.733769	\N
\.


--
-- Data for Name: teams; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."teams" ("id", "category_id", "created_at", "entity_id", "finance_status", "group_key", "name", "registration_status", "short_name", "source_id", "updated_at") FROM stdin;
174	11	2026-09-10 17:05:30.8023	106	pendente	\N	Luiza Bianco Checchia / Henrique Tafarelo	aprovada	\N	tranca-import-6-4d6b5c90c0e31808bc62b0e196d480ecca780a095826fe8526797337deb2dcd5	2026-09-10 17:05:30.8023
177	11	2026-09-10 17:05:35.195103	109	pendente	\N	Rúbia Mara Cineze / Amélia Maria Orsini Platzeck	aprovada	\N	tranca-import-6-953003ae4b2222f129ce542f8aa873b6b7fd0df76cd047cf43e7d32fd1aafe8e	2026-09-10 17:05:35.195103
178	11	2026-09-10 17:05:36.489687	110	pendente	\N	Isis de Aguiar Vallim Lerosa / Dirce Pimentel Levy	aprovada	\N	tranca-import-6-d68d9c5a2f7708af7f1db1bf25da71c3317d4940df70dc2346f6131c8acf40d6	2026-09-10 17:05:36.489687
179	11	2026-09-10 17:05:37.789925	111	pendente	\N	Lais Baptista Silva / Tatiana Baptista Silva Zuccari	aprovada	\N	tranca-import-6-a72bea26a8cf9b010c7d53030aa401e42f1c99bd23fcb0cc8a7e142145109323	2026-09-10 17:05:37.789925
180	11	2026-09-10 17:05:39.109714	112	pendente	\N	Elzibieta Xenia Krygler Catani / Maria Antonieta Vieira Moss	aprovada	\N	tranca-import-6-e6d168cd05f5ef8a9ad565b10f5fb51a25556062f232c2b82dc0263b048d581a	2026-09-10 17:05:39.109714
181	11	2026-09-10 17:05:40.427775	113	pendente	\N	Catharina Parodi / Celia Campagno Cyrino Pereira	aprovada	\N	tranca-import-6-1a35c59ba71e1135ebe98c5e3890d497273e8b1e2e3311a88a02b4874f5d5cfc	2026-09-10 17:05:40.427775
182	11	2026-09-10 17:05:41.72871	114	pendente	\N	Laurinda Rocha Tafarello / Virginia de Barros Basto	aprovada	\N	tranca-import-6-40e827a68885f3c5bad3cd2567357517014466f93bfd6fd8c194849291292ac6	2026-09-10 17:05:41.72871
183	11	2026-09-10 17:05:43.021472	115	pendente	\N	Marco Antonio Gomes / Rita Rocchiccioli	aprovada	\N	tranca-import-6-65e64c1e3b7c224a93694744f543d72481bd11aa55aea2892fdeffe76a928558	2026-09-10 17:05:43.021472
184	11	2026-09-10 17:05:44.30932	116	pendente	\N	Marilena Graziano de A. Barros / Anna Mª Matarazzo Trunkl	aprovada	\N	tranca-import-6-04b0e1fb0bf08b6bf41c7c7431e2b87b40cbd0f5f84883a2efb5aaa4faaa696b	2026-09-10 17:05:44.30932
185	11	2026-09-10 17:05:45.629891	117	pendente	\N	Neuza da Rocha F. Mendes / Neide Neli Richter	aprovada	\N	tranca-import-6-7fc7039e8bc6dafe15e74a8d6e5197b8e7c33e1766cad8951be9d358731cfb6e	2026-09-10 17:05:45.629891
186	11	2026-09-10 17:05:46.925662	118	pendente	\N	Maria Teresa Lima da Costa / Francesly Sanzi	aprovada	\N	tranca-import-6-56d6211102e63e600b608474429b9dc0456326d7919218dbdced51eef66dbf83	2026-09-10 17:05:46.925662
187	11	2026-09-10 17:05:48.243059	119	pendente	\N	Eloísa Maria Amaro / Conceição Pastore de Barros Camargo	aprovada	\N	tranca-import-6-02a7cb629b599f1fbc647756033f9798be59d86148a5bb2d34826f5e5b5be78d	2026-09-10 17:05:48.243059
188	11	2026-09-10 17:05:49.539969	120	pendente	\N	Neide Maria de Carvalho / Sérgio Roberto Granieri	aprovada	\N	tranca-import-6-e86e94240cbe912a60e96e86cc3327f8744cf6542a90fd46578088ba5f1fe7ad	2026-09-10 17:05:49.539969
189	11	2026-09-10 17:05:50.830086	121	pendente	\N	Vera Regina F. Castro Brandão / Stella Maria de Faria Arduino	aprovada	\N	tranca-import-6-eab4be73a60d5bd3681288517dc85ac227eaf5537c8fd2012fe032fe29f01407	2026-09-10 17:05:50.830086
191	11	2026-09-10 17:05:53.40696	123	pendente	\N	Rosana Campi Sophia / Eduardo Luiz Sophia	aprovada	\N	tranca-import-6-35198179812da002f5d118a55c359e35bdd20c93fa976df1d911e889e0cdb8c7	2026-09-10 17:05:53.40696
192	11	2026-09-10 17:05:54.696462	124	pendente	\N	Rosa Maria Barone Russo / Claudia M. G. L. Gregorio	aprovada	\N	tranca-import-6-3feab4c9791be2242887ff8ec2abef46c1e5fb5a0c6eb898f992cdde5725f916	2026-09-10 17:05:54.696462
193	11	2026-09-10 17:05:55.984131	125	pendente	\N	Eliane Avancini (Lili) / Beatriz Andrade Basile	aprovada	\N	tranca-import-6-465abe9757e2cd5529861cb14ddb16747721040847b6ea9f9a1de5f801ad1794	2026-09-10 17:05:55.984131
194	11	2026-09-10 17:05:57.274064	126	pendente	\N	Maria Clara Toledo Fontes / Alice G. Saraiva Dinelli	aprovada	\N	tranca-import-6-55e92b5be52702edf59bfd4e9f421275e6d0f81a7c0080ade4b81fdc39b6ebaa	2026-09-10 17:05:57.274064
195	11	2026-09-10 17:05:58.559914	127	pendente	\N	Sonia Regina Maxemiuk Augusto / Anna Mª Bernardini Della	aprovada	\N	tranca-import-6-5c98436f3b80c28c08ef20ec781384b79fdb46fd68d77f06c0c87f9277bb4473	2026-09-10 17:05:58.559914
196	11	2026-09-10 17:05:59.866082	128	pendente	\N	Monica de Baptista Medina / Paula Cristina Moreira Pires	aprovada	\N	tranca-import-6-a935db4d5b342a08f04d820dcf9d243d35a250d2ddef11227a3013af9aedf4b6	2026-09-10 17:05:59.866082
197	11	2026-09-10 17:06:01.161	129	pendente	\N	Dárcio M. Falcão / Marlene Martiniano de Azevedo	aprovada	\N	tranca-import-6-06aa32f7aece548e64e5b10b8b4107ed708d638999812f7b71789094056b0347	2026-09-10 17:06:01.161
198	11	2026-09-10 17:06:02.453319	130	pendente	\N	Maria Cecília Loviat / Andiara Maria Roessle Guimarães	aprovada	\N	tranca-import-6-6c755f7a8e27349d6c5869446e8eb3fc4097d5375aeebab61add080c1160f916	2026-09-10 17:06:02.453319
199	11	2026-09-10 17:06:03.741096	131	pendente	\N	Eucy Maria Malta Ferreira Cintra de Barros / Marilia Rahal Zorob de Paula Assis	aprovada	\N	tranca-import-6-2dfb2be94c2f296937bad07d72def1bba88cf0972007054903d12a140ceb217f	2026-09-10 17:06:03.741096
200	11	2026-09-10 17:06:05.029994	132	pendente	\N	Luís Roberto Leonel de Arruda / Leila Baptista Silva Zuccari	aprovada	\N	tranca-import-6-b7b38d4add6fca4e1722285c078deb6efa27ca8c3234453655e5629bbc96c723	2026-09-10 17:06:05.029994
201	11	2026-09-10 17:06:06.318759	133	pendente	\N	Erece Assaf Ricotti / Nilde C. Rainho	aprovada	\N	tranca-import-6-37df6c14f261a87899f751653bcf365357a3ed600734f0a965bd05ffa113e106	2026-09-10 17:06:06.318759
203	11	2026-09-10 17:06:08.896282	135	pendente	\N	Luiz Fernando G. de Mello Faro / Fernando Murat de M. Faro	aprovada	\N	tranca-import-6-a7f0e41cde2d83e1c8f68623d22a47228892a3567a9159c7c9aa1be1ac1f251a	2026-09-10 17:06:08.896282
204	11	2026-09-10 17:06:10.186041	136	pendente	\N	Leila Bacelar Chicca / Carolina Bacelar Chicca	aprovada	\N	tranca-import-6-833584ca6be32a4794fce0944925f265b84b092cfaec2a9eed060338cfa4e5bb	2026-09-10 17:06:10.186041
205	11	2026-09-10 17:06:11.475751	137	pendente	\N	Marcia Regina Bacchin / Gizelle Autran	aprovada	\N	tranca-import-6-fa4c8d82f9804a7e6528155e9e3909a142882be3cab2a8a9e7eed1bd2158d8d6	2026-09-10 17:06:11.475751
206	11	2026-09-10 17:06:12.764225	138	pendente	\N	Arnaldo Osse Filho / Glaucia Langbeck Osse	aprovada	\N	tranca-import-6-968089c4b3582fcd1a34c0241995d34362450eda71ee4430434d8a9d9d71cfe2	2026-09-10 17:06:12.764225
208	11	2026-09-10 17:06:15.342919	140	pendente	\N	Adriana Braga / Cleusa B Costa	aprovada	\N	tranca-import-6-f1d797a31f9c2628777a72f4236c06d7213d21200a585e26b59e3174084ff49c	2026-09-10 17:06:15.342919
207	11	2026-09-10 17:06:14.055484	139	pendente	\N	João Gilberto Pacces / Maria de Lourdes Dal Buono	rejeitada	\N	tranca-import-6-5be0ab3c3f394a96389d1e9ca3860d7d22d8be24dcfc5883dcafac5c3ddca5d8	2026-09-12 18:01:20.493673
209	11	2026-09-10 17:06:16.652141	141	pendente	\N	Ana Cecilia F. de Sá Borrelli / Ivan Gonçalves Branco da Silva	rejeitada	\N	tranca-import-6-4124b59fb2ba00dd8e161b7c1b13ce3d6329abc9d7f1083ec368ff80c25b5b0f	2026-09-12 18:01:51.078185
190	11	2026-09-10 17:05:52.119922	122	pendente	\N	Claudia Pirani Xande / Beatriz Helena Tess	rejeitada	\N	tranca-import-6-282d86dcc0eaa955711b45b02849a077816d3b828d5078750d55a979f54f4b43	2026-09-12 18:02:14.965237
176	11	2026-09-10 17:05:33.896508	108	pendente	\N	Antonio Sérgio Fernandes / Carlos Alberto Pedreschi	rejeitada	\N	tranca-import-6-086f12b12f621d0712ec8485e4f1adeef6193114829a990beb8a7dd5d9f5350a	2026-09-12 18:02:37.601397
175	11	2026-09-10 17:05:32.58417	107	pendente	\N	Leon Majer / Maria Helena Serzedo	aprovada	\N	tranca-import-6-cebe7c5dd2775f6a1846b6a6ba48dc34411f5caff8baeb2593b1a8d464137a77	2026-09-12 18:03:31.081879
210	11	2026-09-10 17:06:17.939254	142	pendente	\N	Mario Montenegro Gasparini / Renata Chequer Machado	aprovada	\N	tranca-import-6-b7842b146675503a8f8cd5bd0bd65d61e6df8fdf05e9b370362882f69d87ce85	2026-09-10 17:06:17.939254
212	11	2026-09-10 17:06:20.52019	144	pendente	\N	Telma Magalhães Buckup / Anahi M. Bayma de Carvalho	aprovada	\N	tranca-import-6-19d86aaf88c8c8c0105d692861c29651e34c6aafc1d56240457f766d54610b4b	2026-09-10 17:06:20.52019
213	11	2026-09-10 17:06:21.809711	145	pendente	\N	Carlos Antonio Rossi Rosa / Marcelo Fernando Lopo Lima	aprovada	\N	tranca-import-6-05c3cc03a69d59c0c9a24b627974dbea1582f663a0fa465a54ee77fcf7ef2a2d	2026-09-10 17:06:21.809711
214	11	2026-09-10 17:06:23.102739	146	pendente	\N	Maria Lúcia Stape / Nilda Monteiro Calife	aprovada	\N	tranca-import-6-588428c037acc202ebe1fc374d11020da829a4a80bd7bda1ef3a9cab23f9cf0a	2026-09-10 17:06:23.102739
215	11	2026-09-10 17:06:24.389792	147	pendente	\N	Marilena Simões de Queiroz / Denise F. Pignalosa	aprovada	\N	tranca-import-6-f94ec956b73e0f767d3e8e43261e39aef3b63f7d41d6158bf377f82491d700e3	2026-09-10 17:06:24.389792
202	11	2026-09-10 17:06:07.606087	134	pendente	\N	Fabio Andrade Reinbold / Silvia Moll Reinbold	rejeitada	\N	tranca-import-6-17516303a91fe00dd001e26aa8b7b213b9814c248c84d56645cc53cbd290727c	2026-09-12 18:00:59.933219
211	11	2026-09-10 17:06:19.231679	143	pendente	\N	Leon Majer / Marta Dubrez Pimenta Campos	rejeitada	\N	tranca-import-6-5aaaf0483b8680af2030b4239d4faee3678a169564f983b087894f37293a1a0a	2026-09-12 18:01:37.985534
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."users" ("id", "created_at", "email", "encrypted_password", "preferred_theme", "remember_created_at", "reset_password_sent_at", "reset_password_token", "role", "updated_at") FROM stdin;
2	2026-09-04 16:08:59.19489	quadra@bola-cinco.local	$2a$12$Je59yCqPEe99TFBhiPW10eIllvld5cRwTTR3joKxd1xdzPJLCnwgu	corporate	\N	\N	\N	dono_da_quadra	2026-09-04 16:10:11.452337
3	2026-09-04 16:08:59.89044	tecnico@bola-cinco.local	$2a$12$w78IXZqJUxoGNm6dn68xk./hSxpcWEK.kEB/uihH2.MANSNNi0YZC	corporate	\N	\N	\N	tecnico_do_time	2026-09-04 16:10:12.19204
4	2026-09-04 16:09:00.550603	jogador@bola-cinco.local	$2a$12$597haNanXET.GCa1e3Wd0eabgSAzC2V71NXEg8seQqZstSgMTD22q	corporate	\N	\N	\N	jogador_do_time	2026-09-04 16:10:12.852959
1	2026-09-04 16:08:58.308674	admin@bola-cinco.local	$2a$12$VvJeuW.VdvWQa5rHDXMiaevOwJAhBNpy6pyVO7ktNOFQVy67DNFt2	cruzeiro	\N	\N	\N	adm_master	2026-09-11 16:43:18.872115
\.


--
-- Data for Name: athletes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."athletes" ("id", "birth_certificate", "birth_date", "category_id", "cell_phone", "cpf", "created_at", "document", "documents_count", "email", "gender", "name", "passport", "photo_url", "position", "registration_submitted_at", "rg", "shirt_number", "source_id", "status", "team_id", "updated_at", "user_id", "voter_id") FROM stdin;
96	\N	\N	11	\N	\N	2026-09-10 17:05:31.24054	\N	0	\N	\N	Luiza Bianco Checchia	\N	\N	\N	\N	\N	\N	tranca-import-athlete-6cf5a1dd-e769-46dc-80b2-825539f38dee	pendente	174	2026-09-10 17:05:31.24054	\N	\N
97	\N	\N	11	\N	\N	2026-09-10 17:05:31.371321	\N	0	\N	\N	Henrique Tafarelo	\N	\N	\N	\N	\N	\N	tranca-import-athlete-76414663-c9bb-4a0e-9626-b42c866e73c1	pendente	174	2026-09-10 17:05:31.371321	\N	\N
98	\N	\N	11	\N	\N	2026-09-10 17:05:32.885708	\N	0	\N	\N	Cleid Fernandes	\N	\N	\N	\N	\N	\N	tranca-import-athlete-28b7bc14-7449-48dc-9b6d-c1274b7ee8be	pendente	175	2026-09-10 17:05:32.885708	\N	\N
99	\N	\N	11	\N	\N	2026-09-10 17:05:33.006967	\N	0	\N	\N	Maria Helena Serzedo	\N	\N	\N	\N	\N	\N	tranca-import-athlete-b27975f5-3efe-4418-bddf-d0f4e70faa54	pendente	175	2026-09-10 17:05:33.006967	\N	\N
100	\N	\N	11	\N	\N	2026-09-10 17:05:34.19332	\N	0	\N	\N	Antonio Sérgio Fernandes	\N	\N	\N	\N	\N	\N	tranca-import-athlete-5dc3a27e-9a99-4bdb-911b-1ac3defa5a76	pendente	176	2026-09-10 17:05:34.19332	\N	\N
101	\N	\N	11	\N	\N	2026-09-10 17:05:34.311186	\N	0	\N	\N	Carlos Alberto Pedreschi	\N	\N	\N	\N	\N	\N	tranca-import-athlete-38d1fc57-d2c9-4e52-98f2-5aba0832ada8	pendente	176	2026-09-10 17:05:34.311186	\N	\N
102	\N	\N	11	\N	\N	2026-09-10 17:05:35.489395	\N	0	\N	\N	Rúbia Mara Cineze	\N	\N	\N	\N	\N	\N	tranca-import-athlete-0061760d-233e-47d7-bbb1-ca071ed659f5	pendente	177	2026-09-10 17:05:35.489395	\N	\N
103	\N	\N	11	\N	\N	2026-09-10 17:05:35.606938	\N	0	\N	\N	Amélia Maria Orsini Platzeck	\N	\N	\N	\N	\N	\N	tranca-import-athlete-ecda4eb6-0fd1-44ec-b30e-874b521b12c6	pendente	177	2026-09-10 17:05:35.606938	\N	\N
104	\N	\N	11	\N	\N	2026-09-10 17:05:36.784717	\N	0	\N	\N	Isis de Aguiar Vallim Lerosa	\N	\N	\N	\N	\N	\N	tranca-import-athlete-87db5a92-1dab-491c-8d3c-24a0ce995781	pendente	178	2026-09-10 17:05:36.784717	\N	\N
105	\N	\N	11	\N	\N	2026-09-10 17:05:36.902281	\N	0	\N	\N	Dirce Pimentel Levy	\N	\N	\N	\N	\N	\N	tranca-import-athlete-f7bfd6ec-8def-4934-91f1-92c33195ac45	pendente	178	2026-09-10 17:05:36.902281	\N	\N
106	\N	\N	11	\N	\N	2026-09-10 17:05:38.091715	\N	0	\N	\N	Lais Baptista Silva	\N	\N	\N	\N	\N	\N	tranca-import-athlete-b2ae40d9-51ef-4490-95df-ea1039e8f20e	pendente	179	2026-09-10 17:05:38.091715	\N	\N
107	\N	\N	11	\N	\N	2026-09-10 17:05:38.214079	\N	0	\N	\N	Tatiana Baptista Silva Zuccari	\N	\N	\N	\N	\N	\N	tranca-import-athlete-4ac727de-e520-49da-86f7-84ad7e7862e0	pendente	179	2026-09-10 17:05:38.214079	\N	\N
108	\N	\N	11	\N	\N	2026-09-10 17:05:39.407553	\N	0	\N	\N	Elzibieta Xenia Krygler Catani	\N	\N	\N	\N	\N	\N	tranca-import-athlete-d62e6592-811d-4e0b-a99f-2fb74dc1432c	pendente	180	2026-09-10 17:05:39.407553	\N	\N
109	\N	\N	11	\N	\N	2026-09-10 17:05:39.525445	\N	0	\N	\N	Maria Antonieta Vieira Moss	\N	\N	\N	\N	\N	\N	tranca-import-athlete-7ab697c9-9e5c-4053-88e3-99fae6859222	pendente	180	2026-09-10 17:05:39.525445	\N	\N
110	\N	\N	11	\N	\N	2026-09-10 17:05:40.72968	\N	0	\N	\N	Catharina Parodi	\N	\N	\N	\N	\N	\N	tranca-import-athlete-922d5a9a-57ab-4463-8b65-6c27fd6fcfda	pendente	181	2026-09-10 17:05:40.72968	\N	\N
111	\N	\N	11	\N	\N	2026-09-10 17:05:40.847002	\N	0	\N	\N	Celia Campagno Cyrino Pereira	\N	\N	\N	\N	\N	\N	tranca-import-athlete-191e546d-76d3-40cd-a150-5f0f1af740a2	pendente	181	2026-09-10 17:05:40.847002	\N	\N
112	\N	\N	11	\N	\N	2026-09-10 17:05:42.022227	\N	0	\N	\N	Laurinda Rocha Tafarello	\N	\N	\N	\N	\N	\N	tranca-import-athlete-1fd5d54c-f078-4a1e-87fd-2357ce61a59b	pendente	182	2026-09-10 17:05:42.022227	\N	\N
113	\N	\N	11	\N	\N	2026-09-10 17:05:42.140275	\N	0	\N	\N	Virginia de Barros Basto	\N	\N	\N	\N	\N	\N	tranca-import-athlete-8ecae316-0cd4-48c6-931f-a9709e0dff5f	pendente	182	2026-09-10 17:05:42.140275	\N	\N
114	\N	\N	11	\N	\N	2026-09-10 17:05:43.314182	\N	0	\N	\N	Marco Antonio Gomes	\N	\N	\N	\N	\N	\N	tranca-import-athlete-29995724-570f-4a06-879e-b717819f5f76	pendente	183	2026-09-10 17:05:43.314182	\N	\N
115	\N	\N	11	\N	\N	2026-09-10 17:05:43.431316	\N	0	\N	\N	Rita Rocchiccioli	\N	\N	\N	\N	\N	\N	tranca-import-athlete-a99213db-b64d-479a-ac9c-8092d47f055b	pendente	183	2026-09-10 17:05:43.431316	\N	\N
116	\N	\N	11	\N	\N	2026-09-10 17:05:44.60851	\N	0	\N	\N	Marilena Graziano de A. Barros	\N	\N	\N	\N	\N	\N	tranca-import-athlete-3b8971d2-789b-4ebd-ab20-c407114aa575	pendente	184	2026-09-10 17:05:44.60851	\N	\N
117	\N	\N	11	\N	\N	2026-09-10 17:05:44.731127	\N	0	\N	\N	Anna Mª Matarazzo Trunkl	\N	\N	\N	\N	\N	\N	tranca-import-athlete-d6495c3b-31a0-4fb2-9fc8-7204bbe84595	pendente	184	2026-09-10 17:05:44.731127	\N	\N
118	\N	\N	11	\N	\N	2026-09-10 17:05:45.927108	\N	0	\N	\N	Neuza da Rocha F. Mendes	\N	\N	\N	\N	\N	\N	tranca-import-athlete-edfd1f91-17df-495d-9750-333ce3d00f74	pendente	185	2026-09-10 17:05:45.927108	\N	\N
119	\N	\N	11	\N	\N	2026-09-10 17:05:46.045005	\N	0	\N	\N	Neide Neli Richter	\N	\N	\N	\N	\N	\N	tranca-import-athlete-19d2064c-4200-4c61-b91d-7db4248fcbf1	pendente	185	2026-09-10 17:05:46.045005	\N	\N
120	\N	\N	11	\N	\N	2026-09-10 17:05:47.221749	\N	0	\N	\N	Maria Teresa Lima da Costa	\N	\N	\N	\N	\N	\N	tranca-import-athlete-8671d560-1cc8-4d33-a996-9126f19496ec	pendente	186	2026-09-10 17:05:47.221749	\N	\N
121	\N	\N	11	\N	\N	2026-09-10 17:05:47.33934	\N	0	\N	\N	Francesly Sanzi	\N	\N	\N	\N	\N	\N	tranca-import-athlete-ec936c13-48bd-4e89-be10-b686bb73bdd5	pendente	186	2026-09-10 17:05:47.33934	\N	\N
122	\N	\N	11	\N	\N	2026-09-10 17:05:48.542276	\N	0	\N	\N	Eloísa Maria Amaro	\N	\N	\N	\N	\N	\N	tranca-import-athlete-143dabe6-0269-45ce-8a3a-85166bd6202f	pendente	187	2026-09-10 17:05:48.542276	\N	\N
123	\N	\N	11	\N	\N	2026-09-10 17:05:48.660997	\N	0	\N	\N	Conceição Pastore de Barros Camargo	\N	\N	\N	\N	\N	\N	tranca-import-athlete-c13056f5-6cce-4970-ba16-f78c31fd60b5	pendente	187	2026-09-10 17:05:48.660997	\N	\N
124	\N	\N	11	\N	\N	2026-09-10 17:05:49.832942	\N	0	\N	\N	Neide Maria de Carvalho	\N	\N	\N	\N	\N	\N	tranca-import-athlete-9048a4c1-936c-4fc1-87d8-2b24387076a1	pendente	188	2026-09-10 17:05:49.832942	\N	\N
125	\N	\N	11	\N	\N	2026-09-10 17:05:49.951225	\N	0	\N	\N	Sérgio Roberto Granieri	\N	\N	\N	\N	\N	\N	tranca-import-athlete-be8ce537-9956-4ba8-aa91-306f1b7d323b	pendente	188	2026-09-10 17:05:49.951225	\N	\N
126	\N	\N	11	\N	\N	2026-09-10 17:05:51.123624	\N	0	\N	\N	Vera Regina F. Castro Brandão	\N	\N	\N	\N	\N	\N	tranca-import-athlete-7a42cf7c-b189-452c-9818-b73ae378fea5	pendente	189	2026-09-10 17:05:51.123624	\N	\N
127	\N	\N	11	\N	\N	2026-09-10 17:05:51.241094	\N	0	\N	\N	Stella Maria de Faria Arduino	\N	\N	\N	\N	\N	\N	tranca-import-athlete-cec7d578-9737-423b-862a-29ad4caa7358	pendente	189	2026-09-10 17:05:51.241094	\N	\N
128	\N	\N	11	\N	\N	2026-09-10 17:05:52.412667	\N	0	\N	\N	Claudia Pirani Xande	\N	\N	\N	\N	\N	\N	tranca-import-athlete-33903c13-aa81-4f9a-8113-6534edf9ac54	pendente	190	2026-09-10 17:05:52.412667	\N	\N
129	\N	\N	11	\N	\N	2026-09-10 17:05:52.530395	\N	0	\N	\N	Beatriz Helena Tess	\N	\N	\N	\N	\N	\N	tranca-import-athlete-f79c6a88-39ce-4603-833c-322dec3cee92	pendente	190	2026-09-10 17:05:52.530395	\N	\N
130	\N	\N	11	\N	\N	2026-09-10 17:05:53.700901	\N	0	\N	\N	Rosana Campi Sophia	\N	\N	\N	\N	\N	\N	tranca-import-athlete-8336b374-aeab-4240-983d-d75a9bf11e20	pendente	191	2026-09-10 17:05:53.700901	\N	\N
131	\N	\N	11	\N	\N	2026-09-10 17:05:53.818165	\N	0	\N	\N	Eduardo Luiz Sophia	\N	\N	\N	\N	\N	\N	tranca-import-athlete-b88b5933-2b27-4fb6-80f9-c4c35ef58972	pendente	191	2026-09-10 17:05:53.818165	\N	\N
132	\N	\N	11	\N	\N	2026-09-10 17:05:54.988984	\N	0	\N	\N	Rosa Maria Barone Russo	\N	\N	\N	\N	\N	\N	tranca-import-athlete-ad8ed1f7-2998-49bc-81c5-45e8d2ebd9be	pendente	192	2026-09-10 17:05:54.988984	\N	\N
133	\N	\N	11	\N	\N	2026-09-10 17:05:55.106536	\N	0	\N	\N	Claudia M. G. L. Gregorio	\N	\N	\N	\N	\N	\N	tranca-import-athlete-653356ba-8e22-404d-ad04-400cb5e98208	pendente	192	2026-09-10 17:05:55.106536	\N	\N
134	\N	\N	11	\N	\N	2026-09-10 17:05:56.277523	\N	0	\N	\N	Eliane Avancini (Lili)	\N	\N	\N	\N	\N	\N	tranca-import-athlete-c7469863-44b4-40a9-b0be-79abe9351ed3	pendente	193	2026-09-10 17:05:56.277523	\N	\N
135	\N	\N	11	\N	\N	2026-09-10 17:05:56.394762	\N	0	\N	\N	Beatriz Andrade Basile	\N	\N	\N	\N	\N	\N	tranca-import-athlete-a40e37f4-e7ea-4fb4-9526-2664420f36c0	pendente	193	2026-09-10 17:05:56.394762	\N	\N
136	\N	\N	11	\N	\N	2026-09-10 17:05:57.566175	\N	0	\N	\N	Maria Clara Toledo Fontes	\N	\N	\N	\N	\N	\N	tranca-import-athlete-4015a5cc-a07f-4c15-9914-77146d4e885c	pendente	194	2026-09-10 17:05:57.566175	\N	\N
137	\N	\N	11	\N	\N	2026-09-10 17:05:57.683996	\N	0	\N	\N	Alice G. Saraiva Dinelli	\N	\N	\N	\N	\N	\N	tranca-import-athlete-e44a4401-f485-476a-aaea-e3476b69da09	pendente	194	2026-09-10 17:05:57.683996	\N	\N
138	\N	\N	11	\N	\N	2026-09-10 17:05:58.85269	\N	0	\N	\N	Sonia Regina Maxemiuk Augusto	\N	\N	\N	\N	\N	\N	tranca-import-athlete-e7b088e1-7e3d-4b25-8e03-395bf572d8c3	pendente	195	2026-09-10 17:05:58.85269	\N	\N
139	\N	\N	11	\N	\N	2026-09-10 17:05:58.987687	\N	0	\N	\N	Anna Mª Bernardini Della	\N	\N	\N	\N	\N	\N	tranca-import-athlete-8fb1fcf3-e76a-41ed-b0dd-74aff21937ad	pendente	195	2026-09-10 17:05:58.987687	\N	\N
140	\N	\N	11	\N	\N	2026-09-10 17:06:00.164006	\N	0	\N	\N	Monica de Baptista Medina	\N	\N	\N	\N	\N	\N	tranca-import-athlete-09d53bf5-c673-4065-ae39-c1366ed72059	pendente	196	2026-09-10 17:06:00.164006	\N	\N
141	\N	\N	11	\N	\N	2026-09-10 17:06:00.282979	\N	0	\N	\N	Paula Cristina Moreira Pires	\N	\N	\N	\N	\N	\N	tranca-import-athlete-17f07be1-f27b-41eb-a51c-1c99cd4c53e3	pendente	196	2026-09-10 17:06:00.282979	\N	\N
142	\N	\N	11	\N	\N	2026-09-10 17:06:01.454077	\N	0	\N	\N	Dárcio M. Falcão	\N	\N	\N	\N	\N	\N	tranca-import-athlete-771a9f7e-a8ef-4d69-9a48-c38387929755	pendente	197	2026-09-10 17:06:01.454077	\N	\N
143	\N	\N	11	\N	\N	2026-09-10 17:06:01.571615	\N	0	\N	\N	Marlene Martiniano de Azevedo	\N	\N	\N	\N	\N	\N	tranca-import-athlete-9bb67442-96f3-4f47-bc85-01546faae423	pendente	197	2026-09-10 17:06:01.571615	\N	\N
144	\N	\N	11	\N	\N	2026-09-10 17:06:02.746575	\N	0	\N	\N	Maria Cecília Loviat	\N	\N	\N	\N	\N	\N	tranca-import-athlete-7a99b2d9-2c83-4dea-a843-14e44a998056	pendente	198	2026-09-10 17:06:02.746575	\N	\N
145	\N	\N	11	\N	\N	2026-09-10 17:06:02.86399	\N	0	\N	\N	Andiara Maria Roessle Guimarães	\N	\N	\N	\N	\N	\N	tranca-import-athlete-eef12105-1197-4924-bbe8-69a1c29cae36	pendente	198	2026-09-10 17:06:02.86399	\N	\N
146	\N	\N	11	\N	\N	2026-09-10 17:06:04.033992	\N	0	\N	\N	Eucy Maria Malta Ferreira Cintra de Barros	\N	\N	\N	\N	\N	\N	tranca-import-athlete-f9ddba39-090e-4837-913a-c4c36a293794	pendente	199	2026-09-10 17:06:04.033992	\N	\N
147	\N	\N	11	\N	\N	2026-09-10 17:06:04.151906	\N	0	\N	\N	Marilia Rahal Zorob de Paula Assis	\N	\N	\N	\N	\N	\N	tranca-import-athlete-d8e67025-7663-475b-93e2-11906721907b	pendente	199	2026-09-10 17:06:04.151906	\N	\N
148	\N	\N	11	\N	\N	2026-09-10 17:06:05.324	\N	0	\N	\N	Luís Roberto Leonel de Arruda	\N	\N	\N	\N	\N	\N	tranca-import-athlete-540ec25b-9ce1-4f67-ae9d-8c2036bd8c86	pendente	200	2026-09-10 17:06:05.324	\N	\N
149	\N	\N	11	\N	\N	2026-09-10 17:06:05.44133	\N	0	\N	\N	Leila Baptista Silva Zuccari	\N	\N	\N	\N	\N	\N	tranca-import-athlete-1902eb1f-43be-4ba3-8a55-b75c4bc6b32b	pendente	200	2026-09-10 17:06:05.44133	\N	\N
150	\N	\N	11	\N	\N	2026-09-10 17:06:06.611513	\N	0	\N	\N	Erece Assaf Ricotti	\N	\N	\N	\N	\N	\N	tranca-import-athlete-8c6a2964-1f75-4ca6-9bce-8283c85ed1dc	pendente	201	2026-09-10 17:06:06.611513	\N	\N
151	\N	\N	11	\N	\N	2026-09-10 17:06:06.729204	\N	0	\N	\N	Nilde C. Rainho	\N	\N	\N	\N	\N	\N	tranca-import-athlete-84a2a31d-baca-4677-85b7-b82ecc07f099	pendente	201	2026-09-10 17:06:06.729204	\N	\N
152	\N	\N	11	\N	\N	2026-09-10 17:06:07.899861	\N	0	\N	\N	Fabio Andrade Reinbold	\N	\N	\N	\N	\N	\N	tranca-import-athlete-9333da57-49d4-418c-bc93-4bc9ce606db4	pendente	202	2026-09-10 17:06:07.899861	\N	\N
153	\N	\N	11	\N	\N	2026-09-10 17:06:08.017047	\N	0	\N	\N	Silvia Moll Reinbold	\N	\N	\N	\N	\N	\N	tranca-import-athlete-41203ff7-7f8c-44e6-88f6-167f55dec672	pendente	202	2026-09-10 17:06:08.017047	\N	\N
154	\N	\N	11	\N	\N	2026-09-10 17:06:09.189755	\N	0	\N	\N	Luiz Fernando G. de Mello Faro	\N	\N	\N	\N	\N	\N	tranca-import-athlete-88f5b842-ebdd-4635-b9e0-d301e80ca0b2	pendente	203	2026-09-10 17:06:09.189755	\N	\N
155	\N	\N	11	\N	\N	2026-09-10 17:06:09.306872	\N	0	\N	\N	Fernando Murat de M. Faro	\N	\N	\N	\N	\N	\N	tranca-import-athlete-90ea1f11-06a1-476c-9fc4-48b6779936ea	pendente	203	2026-09-10 17:06:09.306872	\N	\N
156	\N	\N	11	\N	\N	2026-09-10 17:06:10.479214	\N	0	\N	\N	Leila Bacelar Chicca	\N	\N	\N	\N	\N	\N	tranca-import-athlete-dd8ea35e-f6f1-4d75-aacf-43be941c2c0a	pendente	204	2026-09-10 17:06:10.479214	\N	\N
157	\N	\N	11	\N	\N	2026-09-10 17:06:10.596727	\N	0	\N	\N	Carolina Bacelar Chicca	\N	\N	\N	\N	\N	\N	tranca-import-athlete-e8462ea4-7f9f-4f6a-80f6-dd215436f804	pendente	204	2026-09-10 17:06:10.596727	\N	\N
158	\N	\N	11	\N	\N	2026-09-10 17:06:11.769016	\N	0	\N	\N	Marcia Regina Bacchin	\N	\N	\N	\N	\N	\N	tranca-import-athlete-de76f8b3-7cc4-41f3-a5f6-a1283a9960d8	pendente	205	2026-09-10 17:06:11.769016	\N	\N
159	\N	\N	11	\N	\N	2026-09-10 17:06:11.886298	\N	0	\N	\N	Gizelle Autran	\N	\N	\N	\N	\N	\N	tranca-import-athlete-6502f613-d5b8-4612-aae4-6bcd3881cf70	pendente	205	2026-09-10 17:06:11.886298	\N	\N
160	\N	\N	11	\N	\N	2026-09-10 17:06:13.058822	\N	0	\N	\N	Arnaldo Osse Filho	\N	\N	\N	\N	\N	\N	tranca-import-athlete-81a327ba-7cf5-40c6-a000-156682f86581	pendente	206	2026-09-10 17:06:13.058822	\N	\N
161	\N	\N	11	\N	\N	2026-09-10 17:06:13.176266	\N	0	\N	\N	Glaucia Langbeck Osse	\N	\N	\N	\N	\N	\N	tranca-import-athlete-ea161251-805e-437e-822e-dee040816aab	pendente	206	2026-09-10 17:06:13.176266	\N	\N
162	\N	\N	11	\N	\N	2026-09-10 17:06:14.348652	\N	0	\N	\N	João Gilberto Pacces	\N	\N	\N	\N	\N	\N	tranca-import-athlete-7f0b7809-40a7-4bb0-9274-8fd0549fc182	pendente	207	2026-09-10 17:06:14.348652	\N	\N
163	\N	\N	11	\N	\N	2026-09-10 17:06:14.465885	\N	0	\N	\N	Maria de Lourdes Dal Buono	\N	\N	\N	\N	\N	\N	tranca-import-athlete-58e50fd3-a85f-4874-9133-df60c31ed178	pendente	207	2026-09-10 17:06:14.465885	\N	\N
164	\N	\N	11	\N	\N	2026-09-10 17:06:15.63766	\N	0	\N	\N	Adriana Braga	\N	\N	\N	\N	\N	\N	tranca-import-athlete-36f21ea7-b113-4a09-b428-144602e053de	pendente	208	2026-09-10 17:06:15.63766	\N	\N
165	\N	\N	11	\N	\N	2026-09-10 17:06:15.755725	\N	0	\N	\N	Cleusa B Costa	\N	\N	\N	\N	\N	\N	tranca-import-athlete-196d95ae-be98-4918-bb8c-d84429f09e15	pendente	208	2026-09-10 17:06:15.755725	\N	\N
166	\N	\N	11	\N	\N	2026-09-10 17:06:16.945062	\N	0	\N	\N	Ana Cecilia F. de Sá Borrelli	\N	\N	\N	\N	\N	\N	tranca-import-athlete-217661c2-4bfe-40f3-aa11-1434277710b2	pendente	209	2026-09-10 17:06:16.945062	\N	\N
167	\N	\N	11	\N	\N	2026-09-10 17:06:17.062396	\N	0	\N	\N	Ivan Gonçalves Branco da Silva	\N	\N	\N	\N	\N	\N	tranca-import-athlete-e79d091b-b426-48f1-9f1d-c35b53143800	pendente	209	2026-09-10 17:06:17.062396	\N	\N
168	\N	\N	11	\N	\N	2026-09-10 17:06:18.236376	\N	0	\N	\N	Mario Montenegro Gasparini	\N	\N	\N	\N	\N	\N	tranca-import-athlete-10341d41-85a8-4c8f-b7fb-e0ff5c1b4a2d	pendente	210	2026-09-10 17:06:18.236376	\N	\N
169	\N	\N	11	\N	\N	2026-09-10 17:06:18.354529	\N	0	\N	\N	Renata Chequer Machado	\N	\N	\N	\N	\N	\N	tranca-import-athlete-a65d2917-7577-4705-be74-fe670a3d0b84	pendente	210	2026-09-10 17:06:18.354529	\N	\N
170	\N	\N	11	\N	\N	2026-09-10 17:06:19.52548	\N	0	\N	\N	Leon Majer	\N	\N	\N	\N	\N	\N	tranca-import-athlete-0e7cfd6d-cfb5-4316-bb40-7d4b8302267a	pendente	211	2026-09-10 17:06:19.52548	\N	\N
171	\N	\N	11	\N	\N	2026-09-10 17:06:19.64237	\N	0	\N	\N	Marta Dubrez Pimenta Campos	\N	\N	\N	\N	\N	\N	tranca-import-athlete-d740b84e-d819-40c7-b1e2-c779cfb33b9f	pendente	211	2026-09-10 17:06:19.64237	\N	\N
172	\N	\N	11	\N	\N	2026-09-10 17:06:20.812575	\N	0	\N	\N	Telma Magalhães Buckup	\N	\N	\N	\N	\N	\N	tranca-import-athlete-f7d8d5d8-1052-43aa-8201-c1d4bcde97c2	pendente	212	2026-09-10 17:06:20.812575	\N	\N
173	\N	\N	11	\N	\N	2026-09-10 17:06:20.930039	\N	0	\N	\N	Anahi M. Bayma de Carvalho	\N	\N	\N	\N	\N	\N	tranca-import-athlete-9424cca8-bb0d-45f3-bc65-956438854540	pendente	212	2026-09-10 17:06:20.930039	\N	\N
174	\N	\N	11	\N	\N	2026-09-10 17:06:22.104795	\N	0	\N	\N	Carlos Antonio Rossi Rosa	\N	\N	\N	\N	\N	\N	tranca-import-athlete-7457ac50-d378-4f46-887f-19ebe08e3e4f	pendente	213	2026-09-10 17:06:22.104795	\N	\N
175	\N	\N	11	\N	\N	2026-09-10 17:06:22.222314	\N	0	\N	\N	Marcelo Fernando Lopo Lima	\N	\N	\N	\N	\N	\N	tranca-import-athlete-eea5fe32-7191-4821-bc6c-0d11af17c752	pendente	213	2026-09-10 17:06:22.222314	\N	\N
176	\N	\N	11	\N	\N	2026-09-10 17:06:23.39532	\N	0	\N	\N	Maria Lúcia Stape	\N	\N	\N	\N	\N	\N	tranca-import-athlete-5fc0c99b-9e54-40c1-804d-d71b498c92f3	pendente	214	2026-09-10 17:06:23.39532	\N	\N
177	\N	\N	11	\N	\N	2026-09-10 17:06:23.512879	\N	0	\N	\N	Nilda Monteiro Calife	\N	\N	\N	\N	\N	\N	tranca-import-athlete-d855e8d9-b402-45f6-af0e-67179dd12f8e	pendente	214	2026-09-10 17:06:23.512879	\N	\N
178	\N	\N	11	\N	\N	2026-09-10 17:06:24.682288	\N	0	\N	\N	Marilena Simões de Queiroz	\N	\N	\N	\N	\N	\N	tranca-import-athlete-5b1803b9-cf08-46e8-980c-bb33d56fa301	pendente	215	2026-09-10 17:06:24.682288	\N	\N
179	\N	\N	11	\N	\N	2026-09-10 17:06:24.79941	\N	0	\N	\N	Denise F. Pignalosa	\N	\N	\N	\N	\N	\N	tranca-import-athlete-cca57b7a-e60f-4c37-ba83-074ba640adb5	pendente	215	2026-09-10 17:06:24.79941	\N	\N
\.


--
-- Data for Name: audits; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."audits" ("id", "action", "associated_id", "associated_type", "auditable_id", "auditable_type", "audited_changes", "comment", "created_at", "remote_address", "request_uuid", "user_id", "user_type", "username", "version") FROM stdin;
14	update	\N	\N	1	User	---\npreferred_theme:\n- cruzeiro\n- gremio\n	\N	2026-09-11 16:43:04.097717	201.92.129.4	1f49e236-5b1a-41bd-bf68-42adb8acbb49	1	User	\N	1
15	update	\N	\N	1	User	---\npreferred_theme:\n- gremio\n- cruzeiro\n	\N	2026-09-11 16:43:18.891558	201.92.129.4	6a6f5bac-d12e-4458-a9d5-a2b1da7e0f5f	1	User	\N	2
\.


--
-- Data for Name: championship_categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."championship_categories" ("id", "category_id", "championship_id", "created_at", "source_id", "updated_at") FROM stdin;
11	11	6	2026-09-10 17:02:54.571169	championship-category-6-11	2026-09-10 17:02:54.571169
\.


--
-- Data for Name: championship_memberships; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."championship_memberships" ("id", "championship_id", "created_at", "notes", "role", "source_id", "status", "updated_at", "user_id") FROM stdin;
\.


--
-- Data for Name: invoices; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."invoices" ("id", "amount", "category_id", "championship_id", "created_at", "due_date", "entity_id", "status", "updated_at") FROM stdin;
\.


--
-- Data for Name: venues; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."venues" ("id", "address", "championship_id", "city", "created_at", "name", "notes", "short_name", "source_id", "status", "updated_at") FROM stdin;
\.


--
-- Data for Name: matches; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."matches" ("id", "category_id", "championship_id", "code", "created_at", "decision", "group_key", "highlight_videos", "penalties_a", "penalties_b", "phase", "round_number", "scheduled_on", "scheduled_time", "score_a", "score_b", "scorers", "source_a", "source_b", "source_data", "source_id", "status", "team_a_id", "team_b_id", "updated_at", "venue", "venue_id", "winner_id", "wo") FROM stdin;
\.


--
-- Data for Name: match_events; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."match_events" ("id", "athlete_id", "championship_id", "created_at", "kind", "match_id", "minute", "notes", "period", "source_data", "source_id", "team_id", "updated_at") FROM stdin;
\.


--
-- Data for Name: match_participations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."match_participations" ("id", "athlete_id", "athlete_name", "created_at", "match_id", "notes", "position", "shirt_number", "source_id", "status", "team_id", "updated_at") FROM stdin;
\.


--
-- Data for Name: referees; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."referees" ("id", "championship_id", "created_at", "document", "email", "name", "notes", "phone", "source_id", "status", "updated_at") FROM stdin;
\.


--
-- Data for Name: match_reports; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."match_reports" ("id", "approved_at", "created_at", "match_id", "notes", "referee_id", "sheet_url", "source_data", "source_id", "status", "submitted_at", "updated_at") FROM stdin;
\.


--
-- Data for Name: partners; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."partners" ("id", "category_id", "championship_id", "created_at", "highlight", "logo_url", "name", "notes", "source_data", "source_id", "status", "tier", "updated_at", "website_url") FROM stdin;
\.


--
-- Data for Name: round_selections; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."round_selections" ("id", "category_id", "championship_id", "created_at", "notes", "published_at", "round_number", "source_data", "source_id", "title", "updated_at") FROM stdin;
\.


--
-- Data for Name: round_selection_athletes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."round_selection_athletes" ("id", "athlete_id", "created_at", "position", "round_selection_id", "updated_at") FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."schema_migrations" ("version") FROM stdin;
20260903150000
20260903124500
20260902123000
20260902110000
20260901143000
20260901140000
20260826180000
20260826174000
20260826173000
20260826162000
20260826161000
20260826153000
20260826150000
20260826140000
20260826133000
20260826120000
20260826113000
20260826110000
20260826102000
20260826095000
20260826093000
20260826090000
20260824234500
20260824233000
20260824220000
20260824203823
20260824203819
1
20260911140634
20260916150000
\.


--
-- Data for Name: solid_queue_batches; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."solid_queue_batches" ("id", "active_job_batch_id", "description", "on_finish", "on_success", "on_failure", "metadata", "total_jobs", "completed_jobs", "failed_jobs", "enqueued_at", "finished_at", "failed_at", "created_at", "updated_at") FROM stdin;
\.


--
-- Data for Name: solid_queue_jobs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."solid_queue_jobs" ("id", "queue_name", "class_name", "arguments", "priority", "active_job_id", "scheduled_at", "finished_at", "concurrency_key", "created_at", "updated_at", "batch_id") FROM stdin;
488	solid_queue_recurring	SolidQueue::RecurringJob	{"job_class":"SolidQueue::RecurringJob","job_id":"1b9431e7-817d-4c46-8374-efa37f918a13","provider_job_id":null,"queue_name":"solid_queue_recurring","priority":null,"arguments":["SolidQueue::Job.clear_finished_in_batches(sleep_between_batches: 0.3)"],"executions":0,"exception_executions":{},"locale":"en","timezone":"UTC","enqueued_at":"2026-09-23T16:12:00.001806020Z","scheduled_at":"2026-09-23T16:12:00.001772059Z"}	0	1b9431e7-817d-4c46-8374-efa37f918a13	2026-09-23 16:12:00.001772	2026-09-23 16:12:01.40949	\N	2026-09-23 16:12:00.002029	2026-09-23 16:12:01.409783	\N
465	solid_queue_recurring	SolidQueue::RecurringJob	{"job_class":"SolidQueue::RecurringJob","job_id":"c01fa41c-b7c3-49b3-9fc5-14a736172e6e","provider_job_id":null,"queue_name":"solid_queue_recurring","priority":null,"arguments":["SolidQueue::Job.clear_finished_in_batches(sleep_between_batches: 0.3)"],"executions":0,"exception_executions":{},"locale":"en","timezone":"UTC","enqueued_at":"2026-09-22T18:12:00.022010849Z","scheduled_at":"2026-09-22T18:12:00.021965319Z"}	0	c01fa41c-b7c3-49b3-9fc5-14a736172e6e	2026-09-22 18:12:00.021965	2026-09-22 18:12:02.28929	\N	2026-09-22 18:12:00.022262	2026-09-22 18:12:02.289613	\N
466	solid_queue_recurring	SolidQueue::RecurringJob	{"job_class":"SolidQueue::RecurringJob","job_id":"fd3144e9-fc55-448b-afc1-2d11bcc59d76","provider_job_id":null,"queue_name":"solid_queue_recurring","priority":null,"arguments":["SolidQueue::Job.clear_finished_in_batches(sleep_between_batches: 0.3)"],"executions":0,"exception_executions":{},"locale":"en","timezone":"UTC","enqueued_at":"2026-09-22T19:12:00.001987886Z","scheduled_at":"2026-09-22T19:12:00.001577017Z"}	0	fd3144e9-fc55-448b-afc1-2d11bcc59d76	2026-09-22 19:12:00.001577	2026-09-22 19:12:02.142592	\N	2026-09-22 19:12:00.002221	2026-09-22 19:12:02.142875	\N
467	solid_queue_recurring	SolidQueue::RecurringJob	{"job_class":"SolidQueue::RecurringJob","job_id":"4cb45f4c-30fe-4f6a-baa7-093408f9f76d","provider_job_id":null,"queue_name":"solid_queue_recurring","priority":null,"arguments":["SolidQueue::Job.clear_finished_in_batches(sleep_between_batches: 0.3)"],"executions":0,"exception_executions":{},"locale":"en","timezone":"UTC","enqueued_at":"2026-09-22T20:12:00.001659568Z","scheduled_at":"2026-09-22T20:12:00.001628741Z"}	0	4cb45f4c-30fe-4f6a-baa7-093408f9f76d	2026-09-22 20:12:00.001628	2026-09-22 20:12:01.666877	\N	2026-09-22 20:12:00.001864	2026-09-22 20:12:01.667154	\N
474	default	SyncFootballKnockoutBracketsJob	{"job_class":"SyncFootballKnockoutBracketsJob","job_id":"57642c7e-7512-4d6d-b07b-0b867ea38795","provider_job_id":null,"queue_name":"default","priority":null,"arguments":[],"executions":0,"exception_executions":{},"locale":"en","timezone":"UTC","enqueued_at":"2026-09-23T03:00:00.061115446Z","scheduled_at":"2026-09-23T03:00:00.051832309Z"}	0	57642c7e-7512-4d6d-b07b-0b867ea38795	2026-09-23 03:00:00.051832	2026-09-23 03:00:01.280172	\N	2026-09-23 03:00:00.062714	2026-09-23 03:00:01.280542	\N
480	solid_queue_recurring	SolidQueue::RecurringJob	{"job_class":"SolidQueue::RecurringJob","job_id":"2cf18374-c8af-4e9d-9d85-66c2b4ec2412","provider_job_id":null,"queue_name":"solid_queue_recurring","priority":null,"arguments":["SolidQueue::Job.clear_finished_in_batches(sleep_between_batches: 0.3)"],"executions":0,"exception_executions":{},"locale":"en","timezone":"UTC","enqueued_at":"2026-09-23T08:12:00.016628553Z","scheduled_at":"2026-09-23T08:12:00.016576532Z"}	0	2cf18374-c8af-4e9d-9d85-66c2b4ec2412	2026-09-23 08:12:00.016576	2026-09-23 08:12:02.103416	\N	2026-09-23 08:12:00.016859	2026-09-23 08:12:02.103711	\N
486	solid_queue_recurring	SolidQueue::RecurringJob	{"job_class":"SolidQueue::RecurringJob","job_id":"3f2d5ce4-5d52-453e-b87d-b9b3e61fa110","provider_job_id":null,"queue_name":"solid_queue_recurring","priority":null,"arguments":["SolidQueue::Job.clear_finished_in_batches(sleep_between_batches: 0.3)"],"executions":0,"exception_executions":{},"locale":"en","timezone":"UTC","enqueued_at":"2026-09-23T14:12:00.001618861Z","scheduled_at":"2026-09-23T14:12:00.001588486Z"}	0	3f2d5ce4-5d52-453e-b87d-b9b3e61fa110	2026-09-23 14:12:00.001588	2026-09-23 14:12:02.26106	\N	2026-09-23 14:12:00.001821	2026-09-23 14:12:02.261366	\N
468	solid_queue_recurring	SolidQueue::RecurringJob	{"job_class":"SolidQueue::RecurringJob","job_id":"af61d1f1-0030-4421-b84b-e260ede95b6c","provider_job_id":null,"queue_name":"solid_queue_recurring","priority":null,"arguments":["SolidQueue::Job.clear_finished_in_batches(sleep_between_batches: 0.3)"],"executions":0,"exception_executions":{},"locale":"en","timezone":"UTC","enqueued_at":"2026-09-22T21:12:00.014000255Z","scheduled_at":"2026-09-22T21:12:00.013971487Z"}	0	af61d1f1-0030-4421-b84b-e260ede95b6c	2026-09-22 21:12:00.013971	2026-09-22 21:12:02.37914	\N	2026-09-22 21:12:00.014212	2026-09-22 21:12:02.37949	\N
475	solid_queue_recurring	SolidQueue::RecurringJob	{"job_class":"SolidQueue::RecurringJob","job_id":"79f378c9-ed1b-4e29-aa4e-04091e767bd9","provider_job_id":null,"queue_name":"solid_queue_recurring","priority":null,"arguments":["SolidQueue::Job.clear_finished_in_batches(sleep_between_batches: 0.3)"],"executions":0,"exception_executions":{},"locale":"en","timezone":"UTC","enqueued_at":"2026-09-23T03:12:00.008845123Z","scheduled_at":"2026-09-23T03:12:00.002676323Z"}	0	79f378c9-ed1b-4e29-aa4e-04091e767bd9	2026-09-23 03:12:00.002676	2026-09-23 03:12:01.968513	\N	2026-09-23 03:12:00.009199	2026-09-23 03:12:01.968847	\N
481	solid_queue_recurring	SolidQueue::RecurringJob	{"job_class":"SolidQueue::RecurringJob","job_id":"fa0dd485-13d2-4f43-a9fe-f09a1008ab71","provider_job_id":null,"queue_name":"solid_queue_recurring","priority":null,"arguments":["SolidQueue::Job.clear_finished_in_batches(sleep_between_batches: 0.3)"],"executions":0,"exception_executions":{},"locale":"en","timezone":"UTC","enqueued_at":"2026-09-23T09:12:00.006974370Z","scheduled_at":"2026-09-23T09:12:00.006935748Z"}	0	fa0dd485-13d2-4f43-a9fe-f09a1008ab71	2026-09-23 09:12:00.006935	2026-09-23 09:12:02.045914	\N	2026-09-23 09:12:00.007184	2026-09-23 09:12:02.046225	\N
487	solid_queue_recurring	SolidQueue::RecurringJob	{"job_class":"SolidQueue::RecurringJob","job_id":"0a202746-06a1-45d4-b2aa-96b46d9cbb9b","provider_job_id":null,"queue_name":"solid_queue_recurring","priority":null,"arguments":["SolidQueue::Job.clear_finished_in_batches(sleep_between_batches: 0.3)"],"executions":0,"exception_executions":{},"locale":"en","timezone":"UTC","enqueued_at":"2026-09-23T15:12:00.001646912Z","scheduled_at":"2026-09-23T15:12:00.001617028Z"}	0	0a202746-06a1-45d4-b2aa-96b46d9cbb9b	2026-09-23 15:12:00.001617	2026-09-23 15:12:02.75019	\N	2026-09-23 15:12:00.001869	2026-09-23 15:12:02.750507	\N
174	default	ActiveStorage::AnalyzeJob	{"job_class":"ActiveStorage::AnalyzeJob","job_id":"528af095-7a9a-4cd5-8307-abcfbc229222","provider_job_id":null,"queue_name":"default","priority":null,"arguments":[{"_aj_globalid":"gid://bola-cinco/ActiveStorage::Blob/1"}],"executions":0,"exception_executions":{},"locale":"en","timezone":"UTC","enqueued_at":"2026-09-11T15:07:47.641708612Z","scheduled_at":"2026-09-11T15:07:47.582359799Z"}	0	528af095-7a9a-4cd5-8307-abcfbc229222	2026-09-11 15:07:47.582359	\N	\N	2026-09-11 15:07:47.856293	2026-09-11 15:07:47.856293	\N
469	solid_queue_recurring	SolidQueue::RecurringJob	{"job_class":"SolidQueue::RecurringJob","job_id":"f732107e-3f57-490c-801d-e07cb63bfd3d","provider_job_id":null,"queue_name":"solid_queue_recurring","priority":null,"arguments":["SolidQueue::Job.clear_finished_in_batches(sleep_between_batches: 0.3)"],"executions":0,"exception_executions":{},"locale":"en","timezone":"UTC","enqueued_at":"2026-09-22T22:12:00.001612878Z","scheduled_at":"2026-09-22T22:12:00.001579597Z"}	0	f732107e-3f57-490c-801d-e07cb63bfd3d	2026-09-22 22:12:00.001579	2026-09-22 22:12:01.784338	\N	2026-09-22 22:12:00.001828	2026-09-22 22:12:01.784648	\N
476	solid_queue_recurring	SolidQueue::RecurringJob	{"job_class":"SolidQueue::RecurringJob","job_id":"7cdcfeac-5fb7-49de-9a92-321c78225da9","provider_job_id":null,"queue_name":"solid_queue_recurring","priority":null,"arguments":["SolidQueue::Job.clear_finished_in_batches(sleep_between_batches: 0.3)"],"executions":0,"exception_executions":{},"locale":"en","timezone":"UTC","enqueued_at":"2026-09-23T04:12:00.001594239Z","scheduled_at":"2026-09-23T04:12:00.001563281Z"}	0	7cdcfeac-5fb7-49de-9a92-321c78225da9	2026-09-23 04:12:00.001563	2026-09-23 04:12:02.249426	\N	2026-09-23 04:12:00.001799	2026-09-23 04:12:02.249748	\N
482	solid_queue_recurring	SolidQueue::RecurringJob	{"job_class":"SolidQueue::RecurringJob","job_id":"fb913a30-6f76-40bc-a553-bbeadc518205","provider_job_id":null,"queue_name":"solid_queue_recurring","priority":null,"arguments":["SolidQueue::Job.clear_finished_in_batches(sleep_between_batches: 0.3)"],"executions":0,"exception_executions":{},"locale":"en","timezone":"UTC","enqueued_at":"2026-09-23T10:12:00.006188415Z","scheduled_at":"2026-09-23T10:12:00.006161855Z"}	0	fb913a30-6f76-40bc-a553-bbeadc518205	2026-09-23 10:12:00.006161	2026-09-23 10:12:02.577775	\N	2026-09-23 10:12:00.006458	2026-09-23 10:12:02.578069	\N
177	default	ActiveStorage::AnalyzeJob	{"job_class":"ActiveStorage::AnalyzeJob","job_id":"30008bd8-695d-49f7-94c2-892174cd7a72","provider_job_id":null,"queue_name":"default","priority":null,"arguments":[{"_aj_globalid":"gid://bola-cinco/ActiveStorage::Blob/2"}],"executions":0,"exception_executions":{},"locale":"en","timezone":"UTC","enqueued_at":"2026-09-11T15:18:54.763954804Z","scheduled_at":"2026-09-11T15:18:54.762023028Z"}	0	30008bd8-695d-49f7-94c2-892174cd7a72	2026-09-11 15:18:54.762023	\N	\N	2026-09-11 15:18:54.764359	2026-09-11 15:18:54.764359	\N
213	default	ActiveStorage::AnalyzeJob	{"job_class":"ActiveStorage::AnalyzeJob","job_id":"6f13d972-b94e-4217-880f-a81ff5b50970","provider_job_id":null,"queue_name":"default","priority":null,"arguments":[{"_aj_globalid":"gid://bola-cinco/ActiveStorage::Blob/6"}],"executions":0,"exception_executions":{},"locale":"en","timezone":"UTC","enqueued_at":"2026-09-12T18:27:15.780350762Z","scheduled_at":"2026-09-12T18:27:15.764818327Z"}	0	6f13d972-b94e-4217-880f-a81ff5b50970	2026-09-12 18:27:15.764818	\N	\N	2026-09-12 18:27:15.781241	2026-09-12 18:27:15.781241	\N
470	solid_queue_recurring	SolidQueue::RecurringJob	{"job_class":"SolidQueue::RecurringJob","job_id":"ba30485b-e57d-4c1d-a2ee-d3e20e43536d","provider_job_id":null,"queue_name":"solid_queue_recurring","priority":null,"arguments":["SolidQueue::Job.clear_finished_in_batches(sleep_between_batches: 0.3)"],"executions":0,"exception_executions":{},"locale":"en","timezone":"UTC","enqueued_at":"2026-09-22T23:12:00.006018809Z","scheduled_at":"2026-09-22T23:12:00.005992208Z"}	0	ba30485b-e57d-4c1d-a2ee-d3e20e43536d	2026-09-22 23:12:00.005992	2026-09-22 23:12:01.741971	\N	2026-09-22 23:12:00.006221	2026-09-22 23:12:01.742258	\N
477	solid_queue_recurring	SolidQueue::RecurringJob	{"job_class":"SolidQueue::RecurringJob","job_id":"47809231-1e1f-4667-aaf4-b7c82ccd76d5","provider_job_id":null,"queue_name":"solid_queue_recurring","priority":null,"arguments":["SolidQueue::Job.clear_finished_in_batches(sleep_between_batches: 0.3)"],"executions":0,"exception_executions":{},"locale":"en","timezone":"UTC","enqueued_at":"2026-09-23T05:12:00.110734899Z","scheduled_at":"2026-09-23T05:12:00.090139561Z"}	0	47809231-1e1f-4667-aaf4-b7c82ccd76d5	2026-09-23 05:12:00.090139	2026-09-23 05:12:03.047118	\N	2026-09-23 05:12:00.205203	2026-09-23 05:12:03.057199	\N
483	solid_queue_recurring	SolidQueue::RecurringJob	{"job_class":"SolidQueue::RecurringJob","job_id":"bc7e649a-39bf-4109-aa52-51f4140213d7","provider_job_id":null,"queue_name":"solid_queue_recurring","priority":null,"arguments":["SolidQueue::Job.clear_finished_in_batches(sleep_between_batches: 0.3)"],"executions":0,"exception_executions":{},"locale":"en","timezone":"UTC","enqueued_at":"2026-09-23T11:12:00.001601685Z","scheduled_at":"2026-09-23T11:12:00.001572015Z"}	0	bc7e649a-39bf-4109-aa52-51f4140213d7	2026-09-23 11:12:00.001572	2026-09-23 11:12:02.309214	\N	2026-09-23 11:12:00.001804	2026-09-23 11:12:02.309583	\N
179	default	ActiveStorage::AnalyzeJob	{"job_class":"ActiveStorage::AnalyzeJob","job_id":"bb608c8b-fde2-42e5-97b6-2baeccf89fda","provider_job_id":null,"queue_name":"default","priority":null,"arguments":[{"_aj_globalid":"gid://bola-cinco/ActiveStorage::Blob/3"}],"executions":0,"exception_executions":{},"locale":"en","timezone":"UTC","enqueued_at":"2026-09-11T15:19:20.649176828Z","scheduled_at":"2026-09-11T15:19:20.649008283Z"}	0	bb608c8b-fde2-42e5-97b6-2baeccf89fda	2026-09-11 15:19:20.649008	\N	\N	2026-09-11 15:19:20.649687	2026-09-11 15:19:20.649687	\N
463	solid_queue_recurring	SolidQueue::RecurringJob	{"job_class":"SolidQueue::RecurringJob","job_id":"3c4e964c-b585-4545-98c2-67de03865b49","provider_job_id":null,"queue_name":"solid_queue_recurring","priority":null,"arguments":["SolidQueue::Job.clear_finished_in_batches(sleep_between_batches: 0.3)"],"executions":0,"exception_executions":{},"locale":"en","timezone":"UTC","enqueued_at":"2026-09-22T16:12:00.001621352Z","scheduled_at":"2026-09-22T16:12:00.001589311Z"}	0	3c4e964c-b585-4545-98c2-67de03865b49	2026-09-22 16:12:00.001589	2026-09-22 16:12:01.842668	\N	2026-09-22 16:12:00.001828	2026-09-22 16:12:01.842953	\N
181	default	ActiveStorage::AnalyzeJob	{"job_class":"ActiveStorage::AnalyzeJob","job_id":"bd7a2234-9a85-43ed-a87d-1db9d1556c4c","provider_job_id":null,"queue_name":"default","priority":null,"arguments":[{"_aj_globalid":"gid://bola-cinco/ActiveStorage::Blob/4"}],"executions":0,"exception_executions":{},"locale":"en","timezone":"UTC","enqueued_at":"2026-09-11T15:35:24.312083413Z","scheduled_at":"2026-09-11T15:35:24.310986376Z"}	0	bd7a2234-9a85-43ed-a87d-1db9d1556c4c	2026-09-11 15:35:24.310986	\N	\N	2026-09-11 15:35:24.312713	2026-09-11 15:35:24.312713	\N
471	solid_queue_recurring	SolidQueue::RecurringJob	{"job_class":"SolidQueue::RecurringJob","job_id":"af22dd71-064d-43fd-8042-11799d568b00","provider_job_id":null,"queue_name":"solid_queue_recurring","priority":null,"arguments":["SolidQueue::Job.clear_finished_in_batches(sleep_between_batches: 0.3)"],"executions":0,"exception_executions":{},"locale":"en","timezone":"UTC","enqueued_at":"2026-09-23T00:12:00.001616319Z","scheduled_at":"2026-09-23T00:12:00.001585024Z"}	0	af22dd71-064d-43fd-8042-11799d568b00	2026-09-23 00:12:00.001585	2026-09-23 00:12:01.950501	\N	2026-09-23 00:12:00.001825	2026-09-23 00:12:01.950823	\N
478	solid_queue_recurring	SolidQueue::RecurringJob	{"job_class":"SolidQueue::RecurringJob","job_id":"a88d3a64-6d7f-4c63-8bfd-6792a84ca68d","provider_job_id":null,"queue_name":"solid_queue_recurring","priority":null,"arguments":["SolidQueue::Job.clear_finished_in_batches(sleep_between_batches: 0.3)"],"executions":0,"exception_executions":{},"locale":"en","timezone":"UTC","enqueued_at":"2026-09-23T06:12:00.022999942Z","scheduled_at":"2026-09-23T06:12:00.022973251Z"}	0	a88d3a64-6d7f-4c63-8bfd-6792a84ca68d	2026-09-23 06:12:00.022973	2026-09-23 06:12:02.335594	\N	2026-09-23 06:12:00.02476	2026-09-23 06:12:02.335871	\N
484	solid_queue_recurring	SolidQueue::RecurringJob	{"job_class":"SolidQueue::RecurringJob","job_id":"3847c9fe-4ec0-4f14-b8f7-dd6fa1091523","provider_job_id":null,"queue_name":"solid_queue_recurring","priority":null,"arguments":["SolidQueue::Job.clear_finished_in_batches(sleep_between_batches: 0.3)"],"executions":0,"exception_executions":{},"locale":"en","timezone":"UTC","enqueued_at":"2026-09-23T12:12:00.002586770Z","scheduled_at":"2026-09-23T12:12:00.002558831Z"}	0	3847c9fe-4ec0-4f14-b8f7-dd6fa1091523	2026-09-23 12:12:00.002558	2026-09-23 12:12:01.80909	\N	2026-09-23 12:12:00.002785	2026-09-23 12:12:01.809399	\N
464	solid_queue_recurring	SolidQueue::RecurringJob	{"job_class":"SolidQueue::RecurringJob","job_id":"8fbe2827-ea1e-4530-a228-62dae30a8ab5","provider_job_id":null,"queue_name":"solid_queue_recurring","priority":null,"arguments":["SolidQueue::Job.clear_finished_in_batches(sleep_between_batches: 0.3)"],"executions":0,"exception_executions":{},"locale":"en","timezone":"UTC","enqueued_at":"2026-09-22T17:12:00.001639542Z","scheduled_at":"2026-09-22T17:12:00.001608591Z"}	0	8fbe2827-ea1e-4530-a228-62dae30a8ab5	2026-09-22 17:12:00.001608	2026-09-22 17:12:02.15949	\N	2026-09-22 17:12:00.001846	2026-09-22 17:12:02.159774	\N
472	solid_queue_recurring	SolidQueue::RecurringJob	{"job_class":"SolidQueue::RecurringJob","job_id":"cbe3308c-c340-427c-bdc3-42b6df639032","provider_job_id":null,"queue_name":"solid_queue_recurring","priority":null,"arguments":["SolidQueue::Job.clear_finished_in_batches(sleep_between_batches: 0.3)"],"executions":0,"exception_executions":{},"locale":"en","timezone":"UTC","enqueued_at":"2026-09-23T01:12:00.001610463Z","scheduled_at":"2026-09-23T01:12:00.001580268Z"}	0	cbe3308c-c340-427c-bdc3-42b6df639032	2026-09-23 01:12:00.00158	2026-09-23 01:12:02.676603	\N	2026-09-23 01:12:00.001839	2026-09-23 01:12:02.676883	\N
209	default	ActiveStorage::AnalyzeJob	{"job_class":"ActiveStorage::AnalyzeJob","job_id":"02e5db4f-0f07-4c11-b8af-e70993a82ab7","provider_job_id":null,"queue_name":"default","priority":null,"arguments":[{"_aj_globalid":"gid://bola-cinco/ActiveStorage::Blob/5"}],"executions":0,"exception_executions":{},"locale":"en","timezone":"UTC","enqueued_at":"2026-09-12T16:31:26.589802532Z","scheduled_at":"2026-09-12T16:31:26.588805304Z"}	0	02e5db4f-0f07-4c11-b8af-e70993a82ab7	2026-09-12 16:31:26.588805	\N	\N	2026-09-12 16:31:26.591389	2026-09-12 16:31:26.591389	\N
473	solid_queue_recurring	SolidQueue::RecurringJob	{"job_class":"SolidQueue::RecurringJob","job_id":"b5d0477c-a27c-459d-8cd6-a2744aa6067a","provider_job_id":null,"queue_name":"solid_queue_recurring","priority":null,"arguments":["SolidQueue::Job.clear_finished_in_batches(sleep_between_batches: 0.3)"],"executions":0,"exception_executions":{},"locale":"en","timezone":"UTC","enqueued_at":"2026-09-23T02:12:00.001586892Z","scheduled_at":"2026-09-23T02:12:00.001553538Z"}	0	b5d0477c-a27c-459d-8cd6-a2744aa6067a	2026-09-23 02:12:00.001553	2026-09-23 02:12:02.6798	\N	2026-09-23 02:12:00.001789	2026-09-23 02:12:02.680077	\N
479	solid_queue_recurring	SolidQueue::RecurringJob	{"job_class":"SolidQueue::RecurringJob","job_id":"5c5a43b2-9236-4dde-8f6c-e997cb07cd5d","provider_job_id":null,"queue_name":"solid_queue_recurring","priority":null,"arguments":["SolidQueue::Job.clear_finished_in_batches(sleep_between_batches: 0.3)"],"executions":0,"exception_executions":{},"locale":"en","timezone":"UTC","enqueued_at":"2026-09-23T07:12:00.010532213Z","scheduled_at":"2026-09-23T07:12:00.010492229Z"}	0	5c5a43b2-9236-4dde-8f6c-e997cb07cd5d	2026-09-23 07:12:00.010492	2026-09-23 07:12:02.033443	\N	2026-09-23 07:12:00.012822	2026-09-23 07:12:02.033756	\N
340	default	ActiveStorage::AnalyzeJob	{"job_class":"ActiveStorage::AnalyzeJob","job_id":"d3a19f8a-db24-4d79-b19c-a1a7ea0a70d3","provider_job_id":null,"queue_name":"default","priority":null,"arguments":[{"_aj_globalid":"gid://bola-cinco/ActiveStorage::Blob/7"}],"executions":0,"exception_executions":{},"locale":"en","timezone":"UTC","enqueued_at":"2026-09-17T18:41:19.506514047Z","scheduled_at":"2026-09-17T18:41:19.505348315Z"}	0	d3a19f8a-db24-4d79-b19c-a1a7ea0a70d3	2026-09-17 18:41:19.505348	\N	\N	2026-09-17 18:41:19.507372	2026-09-17 18:41:19.507372	\N
485	solid_queue_recurring	SolidQueue::RecurringJob	{"job_class":"SolidQueue::RecurringJob","job_id":"8e0dea41-2731-4237-bd9a-dd7754a7a3dd","provider_job_id":null,"queue_name":"solid_queue_recurring","priority":null,"arguments":["SolidQueue::Job.clear_finished_in_batches(sleep_between_batches: 0.3)"],"executions":0,"exception_executions":{},"locale":"en","timezone":"UTC","enqueued_at":"2026-09-23T13:12:00.001554920Z","scheduled_at":"2026-09-23T13:12:00.001524371Z"}	0	8e0dea41-2731-4237-bd9a-dd7754a7a3dd	2026-09-23 13:12:00.001524	2026-09-23 13:12:02.43685	\N	2026-09-23 13:12:00.001758	2026-09-23 13:12:02.437134	\N
\.


--
-- Data for Name: solid_queue_batch_executions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."solid_queue_batch_executions" ("id", "job_id", "batch_id", "created_at") FROM stdin;
\.


--
-- Data for Name: solid_queue_blocked_executions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."solid_queue_blocked_executions" ("id", "job_id", "queue_name", "priority", "concurrency_key", "expires_at", "created_at") FROM stdin;
\.


--
-- Data for Name: solid_queue_claimed_executions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."solid_queue_claimed_executions" ("id", "job_id", "process_id", "created_at") FROM stdin;
\.


--
-- Data for Name: solid_queue_failed_executions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."solid_queue_failed_executions" ("id", "job_id", "error", "created_at") FROM stdin;
1	174	{"exception_class":"ActiveStorage::FileNotFoundError","message":"ActiveStorage::FileNotFoundError","backtrace":["/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/service/disk_service.rb:192:in 'ActiveStorage::Service::DiskService#stream'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/service/disk_service.rb:31:in 'block in ActiveStorage::Service::DiskService#download'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/notifications.rb:210:in 'block in ActiveSupport::Notifications.instrument'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/notifications/instrumenter.rb:58:in 'ActiveSupport::Notifications::Instrumenter#instrument'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/notifications.rb:210:in 'ActiveSupport::Notifications.instrument'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/service.rb:169:in 'ActiveStorage::Service#instrument'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/service/disk_service.rb:30:in 'ActiveStorage::Service::DiskService#download'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/downloader.rb:32:in 'ActiveStorage::Downloader#download'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/downloader.rb:13:in 'block in ActiveStorage::Downloader#open'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/downloader.rb:24:in 'ActiveStorage::Downloader#open_tempfile'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/downloader.rb:12:in 'ActiveStorage::Downloader#open'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/service.rb:92:in 'ActiveStorage::Service#open'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/app/models/active_storage/blob.rb:310:in 'ActiveStorage::Blob#open'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/analyzer.rb:35:in 'ActiveStorage::Analyzer#download_blob_to_tempfile'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/analyzer/image_analyzer/vips.rb:20:in 'ActiveStorage::Analyzer::ImageAnalyzer::Vips#read_image'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/analyzer/image_analyzer.rb:25:in 'ActiveStorage::Analyzer::ImageAnalyzer#metadata'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/app/models/active_storage/blob/analyzable.rb:52:in 'ActiveStorage::Blob::Analyzable#extract_metadata_via_analyzer'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/app/models/active_storage/blob/analyzable.rb:30:in 'ActiveStorage::Blob::Analyzable#analyze'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/app/jobs/active_storage/analyze_job.rb:11:in 'ActiveStorage::AnalyzeJob#perform'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/execution.rb:68:in 'block in ActiveJob::Execution#_perform_job'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/callbacks.rb:101:in 'ActiveSupport::Callbacks#run_callbacks'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/execution.rb:67:in 'ActiveJob::Execution#_perform_job'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/instrumentation.rb:44:in 'ActiveJob::Instrumentation#_perform_job'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/execution.rb:51:in 'ActiveJob::Execution#perform_now'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/instrumentation.rb:26:in 'block in ActiveJob::Instrumentation#perform_now'","/usr/local/bundle/ruby/3.4.0/gems/activerecord-8.1.3.1/lib/active_record/railties/job_runtime.rb:12:in 'block in ActiveRecord::Railties::JobRuntime#instrument'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/instrumentation.rb:34:in 'block in ActiveJob::Instrumentation#instrument'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/notifications.rb:210:in 'block in ActiveSupport::Notifications.instrument'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/notifications/instrumenter.rb:58:in 'ActiveSupport::Notifications::Instrumenter#instrument'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/notifications.rb:210:in 'ActiveSupport::Notifications.instrument'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/instrumentation.rb:33:in 'ActiveJob::Instrumentation#instrument'","/usr/local/bundle/ruby/3.4.0/gems/activerecord-8.1.3.1/lib/active_record/railties/job_runtime.rb:10:in 'ActiveRecord::Railties::JobRuntime#instrument'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/instrumentation.rb:26:in 'ActiveJob::Instrumentation#perform_now'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/logging.rb:32:in 'block in ActiveJob::Logging#perform_now'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/tagged_logging.rb:143:in 'block in ActiveSupport::TaggedLogging#tagged'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/tagged_logging.rb:38:in 'ActiveSupport::TaggedLogging::Formatter#tagged'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/tagged_logging.rb:143:in 'ActiveSupport::TaggedLogging#tagged'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/broadcast_logger.rb:228:in 'ActiveSupport::BroadcastLogger#method_missing'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/logging.rb:39:in 'ActiveJob::Logging#tag_logger'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/logging.rb:32:in 'ActiveJob::Logging#perform_now'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/execution_state.rb:7:in 'block (2 levels) in ActiveJob::ExecutionState#perform_now'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/core_ext/time/zones.rb:65:in 'Time.use_zone'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/execution_state.rb:7:in 'block in ActiveJob::ExecutionState#perform_now'","/usr/local/bundle/ruby/3.4.0/gems/i18n-1.15.2/lib/i18n.rb:383:in 'I18n::Base#with_locale'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/execution_state.rb:6:in 'ActiveJob::ExecutionState#perform_now'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/execution.rb:29:in 'block in ActiveJob::Execution::ClassMethods#execute'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/callbacks.rb:121:in 'block in ActiveSupport::Callbacks#run_callbacks'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/railtie.rb:86:in 'block (4 levels) in \\u003cclass:Railtie\\u003e'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/reloader.rb:77:in 'block in ActiveSupport::Reloader.wrap'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/execution_wrapper.rb:87:in 'ActiveSupport::ExecutionWrapper.wrap'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/reloader.rb:74:in 'ActiveSupport::Reloader.wrap'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/railtie.rb:85:in 'block (3 levels) in \\u003cclass:Railtie\\u003e'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/callbacks.rb:130:in 'BasicObject#instance_exec'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/callbacks.rb:130:in 'block in ActiveSupport::Callbacks#run_callbacks'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/callbacks.rb:141:in 'ActiveSupport::Callbacks#run_callbacks'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/execution.rb:27:in 'ActiveJob::Execution::ClassMethods#execute'","/usr/local/bundle/ruby/3.4.0/gems/solid_queue-1.7.0/app/models/solid_queue/claimed_execution.rb:95:in 'SolidQueue::ClaimedExecution#execute'","/usr/local/bundle/ruby/3.4.0/gems/solid_queue-1.7.0/app/models/solid_queue/claimed_execution.rb:66:in 'SolidQueue::ClaimedExecution#perform'","/usr/local/bundle/ruby/3.4.0/gems/solid_queue-1.7.0/lib/solid_queue/pool.rb:51:in 'block in SolidQueue::Pool#perform_execution'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/execution_wrapper.rb:91:in 'ActiveSupport::ExecutionWrapper.wrap'","/usr/local/bundle/ruby/3.4.0/gems/solid_queue-1.7.0/lib/solid_queue/app_executor.rb:7:in 'SolidQueue::AppExecutor#wrap_in_app_executor'","/usr/local/bundle/ruby/3.4.0/gems/solid_queue-1.7.0/lib/solid_queue/pool.rb:51:in 'SolidQueue::Pool#perform_execution'","/usr/local/bundle/ruby/3.4.0/gems/solid_queue-1.7.0/lib/solid_queue/thread_pool.rb:16:in 'block in SolidQueue::ThreadPool#schedule'","/usr/local/bundle/ruby/3.4.0/gems/concurrent-ruby-1.3.8/lib/concurrent-ruby/concurrent/promises.rb:1599:in 'Concurrent::Promises::AbstractPromise#evaluate_to'","/usr/local/bundle/ruby/3.4.0/gems/concurrent-ruby-1.3.8/lib/concurrent-ruby/concurrent/promises.rb:1782:in 'block in Concurrent::Promises::ChainPromise#on_resolvable'","/usr/local/bundle/ruby/3.4.0/gems/concurrent-ruby-1.3.8/lib/concurrent-ruby/concurrent/executor/ruby_thread_pool_executor.rb:382:in 'Concurrent::RubyThreadPoolExecutor::Worker#run_task'","/usr/local/bundle/ruby/3.4.0/gems/concurrent-ruby-1.3.8/lib/concurrent-ruby/concurrent/executor/ruby_thread_pool_executor.rb:372:in 'block (3 levels) in Concurrent::RubyThreadPoolExecutor::Worker#create_worker'","\\u003cinternal:kernel\\u003e:168:in 'Kernel#loop'","/usr/local/bundle/ruby/3.4.0/gems/concurrent-ruby-1.3.8/lib/concurrent-ruby/concurrent/executor/ruby_thread_pool_executor.rb:361:in 'block (2 levels) in Concurrent::RubyThreadPoolExecutor::Worker#create_worker'","/usr/local/bundle/ruby/3.4.0/gems/concurrent-ruby-1.3.8/lib/concurrent-ruby/concurrent/executor/ruby_thread_pool_executor.rb:358:in 'Kernel#catch'","/usr/local/bundle/ruby/3.4.0/gems/concurrent-ruby-1.3.8/lib/concurrent-ruby/concurrent/executor/ruby_thread_pool_executor.rb:358:in 'block in Concurrent::RubyThreadPoolExecutor::Worker#create_worker'"]}	2026-09-11 15:08:06.537377
2	177	{"exception_class":"ActiveStorage::FileNotFoundError","message":"ActiveStorage::FileNotFoundError","backtrace":["/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/service/disk_service.rb:192:in 'ActiveStorage::Service::DiskService#stream'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/service/disk_service.rb:31:in 'block in ActiveStorage::Service::DiskService#download'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/notifications.rb:210:in 'block in ActiveSupport::Notifications.instrument'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/notifications/instrumenter.rb:58:in 'ActiveSupport::Notifications::Instrumenter#instrument'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/notifications.rb:210:in 'ActiveSupport::Notifications.instrument'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/service.rb:169:in 'ActiveStorage::Service#instrument'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/service/disk_service.rb:30:in 'ActiveStorage::Service::DiskService#download'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/downloader.rb:32:in 'ActiveStorage::Downloader#download'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/downloader.rb:13:in 'block in ActiveStorage::Downloader#open'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/downloader.rb:24:in 'ActiveStorage::Downloader#open_tempfile'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/downloader.rb:12:in 'ActiveStorage::Downloader#open'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/service.rb:92:in 'ActiveStorage::Service#open'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/app/models/active_storage/blob.rb:310:in 'ActiveStorage::Blob#open'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/analyzer.rb:35:in 'ActiveStorage::Analyzer#download_blob_to_tempfile'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/analyzer/image_analyzer/vips.rb:20:in 'ActiveStorage::Analyzer::ImageAnalyzer::Vips#read_image'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/analyzer/image_analyzer.rb:25:in 'ActiveStorage::Analyzer::ImageAnalyzer#metadata'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/app/models/active_storage/blob/analyzable.rb:52:in 'ActiveStorage::Blob::Analyzable#extract_metadata_via_analyzer'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/app/models/active_storage/blob/analyzable.rb:30:in 'ActiveStorage::Blob::Analyzable#analyze'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/app/jobs/active_storage/analyze_job.rb:11:in 'ActiveStorage::AnalyzeJob#perform'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/execution.rb:68:in 'block in ActiveJob::Execution#_perform_job'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/callbacks.rb:101:in 'ActiveSupport::Callbacks#run_callbacks'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/execution.rb:67:in 'ActiveJob::Execution#_perform_job'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/instrumentation.rb:44:in 'ActiveJob::Instrumentation#_perform_job'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/execution.rb:51:in 'ActiveJob::Execution#perform_now'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/instrumentation.rb:26:in 'block in ActiveJob::Instrumentation#perform_now'","/usr/local/bundle/ruby/3.4.0/gems/activerecord-8.1.3.1/lib/active_record/railties/job_runtime.rb:12:in 'block in ActiveRecord::Railties::JobRuntime#instrument'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/instrumentation.rb:34:in 'block in ActiveJob::Instrumentation#instrument'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/notifications.rb:210:in 'block in ActiveSupport::Notifications.instrument'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/notifications/instrumenter.rb:58:in 'ActiveSupport::Notifications::Instrumenter#instrument'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/notifications.rb:210:in 'ActiveSupport::Notifications.instrument'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/instrumentation.rb:33:in 'ActiveJob::Instrumentation#instrument'","/usr/local/bundle/ruby/3.4.0/gems/activerecord-8.1.3.1/lib/active_record/railties/job_runtime.rb:10:in 'ActiveRecord::Railties::JobRuntime#instrument'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/instrumentation.rb:26:in 'ActiveJob::Instrumentation#perform_now'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/logging.rb:32:in 'block in ActiveJob::Logging#perform_now'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/tagged_logging.rb:143:in 'block in ActiveSupport::TaggedLogging#tagged'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/tagged_logging.rb:38:in 'ActiveSupport::TaggedLogging::Formatter#tagged'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/tagged_logging.rb:143:in 'ActiveSupport::TaggedLogging#tagged'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/broadcast_logger.rb:228:in 'ActiveSupport::BroadcastLogger#method_missing'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/logging.rb:39:in 'ActiveJob::Logging#tag_logger'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/logging.rb:32:in 'ActiveJob::Logging#perform_now'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/execution_state.rb:7:in 'block (2 levels) in ActiveJob::ExecutionState#perform_now'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/core_ext/time/zones.rb:65:in 'Time.use_zone'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/execution_state.rb:7:in 'block in ActiveJob::ExecutionState#perform_now'","/usr/local/bundle/ruby/3.4.0/gems/i18n-1.15.2/lib/i18n.rb:383:in 'I18n::Base#with_locale'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/execution_state.rb:6:in 'ActiveJob::ExecutionState#perform_now'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/execution.rb:29:in 'block in ActiveJob::Execution::ClassMethods#execute'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/callbacks.rb:121:in 'block in ActiveSupport::Callbacks#run_callbacks'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/railtie.rb:86:in 'block (4 levels) in \\u003cclass:Railtie\\u003e'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/reloader.rb:77:in 'block in ActiveSupport::Reloader.wrap'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/execution_wrapper.rb:87:in 'ActiveSupport::ExecutionWrapper.wrap'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/reloader.rb:74:in 'ActiveSupport::Reloader.wrap'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/railtie.rb:85:in 'block (3 levels) in \\u003cclass:Railtie\\u003e'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/callbacks.rb:130:in 'BasicObject#instance_exec'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/callbacks.rb:130:in 'block in ActiveSupport::Callbacks#run_callbacks'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/callbacks.rb:141:in 'ActiveSupport::Callbacks#run_callbacks'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/execution.rb:27:in 'ActiveJob::Execution::ClassMethods#execute'","/usr/local/bundle/ruby/3.4.0/gems/solid_queue-1.7.0/app/models/solid_queue/claimed_execution.rb:95:in 'SolidQueue::ClaimedExecution#execute'","/usr/local/bundle/ruby/3.4.0/gems/solid_queue-1.7.0/app/models/solid_queue/claimed_execution.rb:66:in 'SolidQueue::ClaimedExecution#perform'","/usr/local/bundle/ruby/3.4.0/gems/solid_queue-1.7.0/lib/solid_queue/pool.rb:51:in 'block in SolidQueue::Pool#perform_execution'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/execution_wrapper.rb:91:in 'ActiveSupport::ExecutionWrapper.wrap'","/usr/local/bundle/ruby/3.4.0/gems/solid_queue-1.7.0/lib/solid_queue/app_executor.rb:7:in 'SolidQueue::AppExecutor#wrap_in_app_executor'","/usr/local/bundle/ruby/3.4.0/gems/solid_queue-1.7.0/lib/solid_queue/pool.rb:51:in 'SolidQueue::Pool#perform_execution'","/usr/local/bundle/ruby/3.4.0/gems/solid_queue-1.7.0/lib/solid_queue/thread_pool.rb:16:in 'block in SolidQueue::ThreadPool#schedule'","/usr/local/bundle/ruby/3.4.0/gems/concurrent-ruby-1.3.8/lib/concurrent-ruby/concurrent/promises.rb:1599:in 'Concurrent::Promises::AbstractPromise#evaluate_to'","/usr/local/bundle/ruby/3.4.0/gems/concurrent-ruby-1.3.8/lib/concurrent-ruby/concurrent/promises.rb:1782:in 'block in Concurrent::Promises::ChainPromise#on_resolvable'","/usr/local/bundle/ruby/3.4.0/gems/concurrent-ruby-1.3.8/lib/concurrent-ruby/concurrent/executor/ruby_thread_pool_executor.rb:382:in 'Concurrent::RubyThreadPoolExecutor::Worker#run_task'","/usr/local/bundle/ruby/3.4.0/gems/concurrent-ruby-1.3.8/lib/concurrent-ruby/concurrent/executor/ruby_thread_pool_executor.rb:372:in 'block (3 levels) in Concurrent::RubyThreadPoolExecutor::Worker#create_worker'","\\u003cinternal:kernel\\u003e:168:in 'Kernel#loop'","/usr/local/bundle/ruby/3.4.0/gems/concurrent-ruby-1.3.8/lib/concurrent-ruby/concurrent/executor/ruby_thread_pool_executor.rb:361:in 'block (2 levels) in Concurrent::RubyThreadPoolExecutor::Worker#create_worker'","/usr/local/bundle/ruby/3.4.0/gems/concurrent-ruby-1.3.8/lib/concurrent-ruby/concurrent/executor/ruby_thread_pool_executor.rb:358:in 'Kernel#catch'","/usr/local/bundle/ruby/3.4.0/gems/concurrent-ruby-1.3.8/lib/concurrent-ruby/concurrent/executor/ruby_thread_pool_executor.rb:358:in 'block in Concurrent::RubyThreadPoolExecutor::Worker#create_worker'"]}	2026-09-11 15:18:57.971236
3	179	{"exception_class":"ActiveStorage::FileNotFoundError","message":"ActiveStorage::FileNotFoundError","backtrace":["/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/service/disk_service.rb:192:in 'ActiveStorage::Service::DiskService#stream'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/service/disk_service.rb:31:in 'block in ActiveStorage::Service::DiskService#download'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/notifications.rb:210:in 'block in ActiveSupport::Notifications.instrument'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/notifications/instrumenter.rb:58:in 'ActiveSupport::Notifications::Instrumenter#instrument'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/notifications.rb:210:in 'ActiveSupport::Notifications.instrument'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/service.rb:169:in 'ActiveStorage::Service#instrument'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/service/disk_service.rb:30:in 'ActiveStorage::Service::DiskService#download'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/downloader.rb:32:in 'ActiveStorage::Downloader#download'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/downloader.rb:13:in 'block in ActiveStorage::Downloader#open'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/downloader.rb:24:in 'ActiveStorage::Downloader#open_tempfile'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/downloader.rb:12:in 'ActiveStorage::Downloader#open'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/service.rb:92:in 'ActiveStorage::Service#open'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/app/models/active_storage/blob.rb:310:in 'ActiveStorage::Blob#open'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/analyzer.rb:35:in 'ActiveStorage::Analyzer#download_blob_to_tempfile'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/analyzer/image_analyzer/vips.rb:20:in 'ActiveStorage::Analyzer::ImageAnalyzer::Vips#read_image'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/analyzer/image_analyzer.rb:25:in 'ActiveStorage::Analyzer::ImageAnalyzer#metadata'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/app/models/active_storage/blob/analyzable.rb:52:in 'ActiveStorage::Blob::Analyzable#extract_metadata_via_analyzer'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/app/models/active_storage/blob/analyzable.rb:30:in 'ActiveStorage::Blob::Analyzable#analyze'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/app/jobs/active_storage/analyze_job.rb:11:in 'ActiveStorage::AnalyzeJob#perform'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/execution.rb:68:in 'block in ActiveJob::Execution#_perform_job'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/callbacks.rb:101:in 'ActiveSupport::Callbacks#run_callbacks'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/execution.rb:67:in 'ActiveJob::Execution#_perform_job'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/instrumentation.rb:44:in 'ActiveJob::Instrumentation#_perform_job'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/execution.rb:51:in 'ActiveJob::Execution#perform_now'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/instrumentation.rb:26:in 'block in ActiveJob::Instrumentation#perform_now'","/usr/local/bundle/ruby/3.4.0/gems/activerecord-8.1.3.1/lib/active_record/railties/job_runtime.rb:12:in 'block in ActiveRecord::Railties::JobRuntime#instrument'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/instrumentation.rb:34:in 'block in ActiveJob::Instrumentation#instrument'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/notifications.rb:210:in 'block in ActiveSupport::Notifications.instrument'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/notifications/instrumenter.rb:58:in 'ActiveSupport::Notifications::Instrumenter#instrument'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/notifications.rb:210:in 'ActiveSupport::Notifications.instrument'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/instrumentation.rb:33:in 'ActiveJob::Instrumentation#instrument'","/usr/local/bundle/ruby/3.4.0/gems/activerecord-8.1.3.1/lib/active_record/railties/job_runtime.rb:10:in 'ActiveRecord::Railties::JobRuntime#instrument'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/instrumentation.rb:26:in 'ActiveJob::Instrumentation#perform_now'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/logging.rb:32:in 'block in ActiveJob::Logging#perform_now'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/tagged_logging.rb:143:in 'block in ActiveSupport::TaggedLogging#tagged'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/tagged_logging.rb:38:in 'ActiveSupport::TaggedLogging::Formatter#tagged'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/tagged_logging.rb:143:in 'ActiveSupport::TaggedLogging#tagged'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/broadcast_logger.rb:228:in 'ActiveSupport::BroadcastLogger#method_missing'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/logging.rb:39:in 'ActiveJob::Logging#tag_logger'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/logging.rb:32:in 'ActiveJob::Logging#perform_now'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/execution_state.rb:7:in 'block (2 levels) in ActiveJob::ExecutionState#perform_now'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/core_ext/time/zones.rb:65:in 'Time.use_zone'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/execution_state.rb:7:in 'block in ActiveJob::ExecutionState#perform_now'","/usr/local/bundle/ruby/3.4.0/gems/i18n-1.15.2/lib/i18n.rb:383:in 'I18n::Base#with_locale'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/execution_state.rb:6:in 'ActiveJob::ExecutionState#perform_now'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/execution.rb:29:in 'block in ActiveJob::Execution::ClassMethods#execute'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/callbacks.rb:121:in 'block in ActiveSupport::Callbacks#run_callbacks'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/railtie.rb:86:in 'block (4 levels) in \\u003cclass:Railtie\\u003e'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/reloader.rb:77:in 'block in ActiveSupport::Reloader.wrap'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/execution_wrapper.rb:87:in 'ActiveSupport::ExecutionWrapper.wrap'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/reloader.rb:74:in 'ActiveSupport::Reloader.wrap'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/railtie.rb:85:in 'block (3 levels) in \\u003cclass:Railtie\\u003e'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/callbacks.rb:130:in 'BasicObject#instance_exec'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/callbacks.rb:130:in 'block in ActiveSupport::Callbacks#run_callbacks'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/callbacks.rb:141:in 'ActiveSupport::Callbacks#run_callbacks'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/execution.rb:27:in 'ActiveJob::Execution::ClassMethods#execute'","/usr/local/bundle/ruby/3.4.0/gems/solid_queue-1.7.0/app/models/solid_queue/claimed_execution.rb:95:in 'SolidQueue::ClaimedExecution#execute'","/usr/local/bundle/ruby/3.4.0/gems/solid_queue-1.7.0/app/models/solid_queue/claimed_execution.rb:66:in 'SolidQueue::ClaimedExecution#perform'","/usr/local/bundle/ruby/3.4.0/gems/solid_queue-1.7.0/lib/solid_queue/pool.rb:51:in 'block in SolidQueue::Pool#perform_execution'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/execution_wrapper.rb:91:in 'ActiveSupport::ExecutionWrapper.wrap'","/usr/local/bundle/ruby/3.4.0/gems/solid_queue-1.7.0/lib/solid_queue/app_executor.rb:7:in 'SolidQueue::AppExecutor#wrap_in_app_executor'","/usr/local/bundle/ruby/3.4.0/gems/solid_queue-1.7.0/lib/solid_queue/pool.rb:51:in 'SolidQueue::Pool#perform_execution'","/usr/local/bundle/ruby/3.4.0/gems/solid_queue-1.7.0/lib/solid_queue/thread_pool.rb:16:in 'block in SolidQueue::ThreadPool#schedule'","/usr/local/bundle/ruby/3.4.0/gems/concurrent-ruby-1.3.8/lib/concurrent-ruby/concurrent/promises.rb:1599:in 'Concurrent::Promises::AbstractPromise#evaluate_to'","/usr/local/bundle/ruby/3.4.0/gems/concurrent-ruby-1.3.8/lib/concurrent-ruby/concurrent/promises.rb:1782:in 'block in Concurrent::Promises::ChainPromise#on_resolvable'","/usr/local/bundle/ruby/3.4.0/gems/concurrent-ruby-1.3.8/lib/concurrent-ruby/concurrent/executor/ruby_thread_pool_executor.rb:382:in 'Concurrent::RubyThreadPoolExecutor::Worker#run_task'","/usr/local/bundle/ruby/3.4.0/gems/concurrent-ruby-1.3.8/lib/concurrent-ruby/concurrent/executor/ruby_thread_pool_executor.rb:372:in 'block (3 levels) in Concurrent::RubyThreadPoolExecutor::Worker#create_worker'","\\u003cinternal:kernel\\u003e:168:in 'Kernel#loop'","/usr/local/bundle/ruby/3.4.0/gems/concurrent-ruby-1.3.8/lib/concurrent-ruby/concurrent/executor/ruby_thread_pool_executor.rb:361:in 'block (2 levels) in Concurrent::RubyThreadPoolExecutor::Worker#create_worker'","/usr/local/bundle/ruby/3.4.0/gems/concurrent-ruby-1.3.8/lib/concurrent-ruby/concurrent/executor/ruby_thread_pool_executor.rb:358:in 'Kernel#catch'","/usr/local/bundle/ruby/3.4.0/gems/concurrent-ruby-1.3.8/lib/concurrent-ruby/concurrent/executor/ruby_thread_pool_executor.rb:358:in 'block in Concurrent::RubyThreadPoolExecutor::Worker#create_worker'"]}	2026-09-11 15:19:22.187915
4	181	{"exception_class":"ActiveStorage::FileNotFoundError","message":"ActiveStorage::FileNotFoundError","backtrace":["/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/service/disk_service.rb:192:in 'ActiveStorage::Service::DiskService#stream'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/service/disk_service.rb:31:in 'block in ActiveStorage::Service::DiskService#download'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/notifications.rb:210:in 'block in ActiveSupport::Notifications.instrument'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/notifications/instrumenter.rb:58:in 'ActiveSupport::Notifications::Instrumenter#instrument'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/notifications.rb:210:in 'ActiveSupport::Notifications.instrument'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/service.rb:169:in 'ActiveStorage::Service#instrument'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/service/disk_service.rb:30:in 'ActiveStorage::Service::DiskService#download'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/downloader.rb:32:in 'ActiveStorage::Downloader#download'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/downloader.rb:13:in 'block in ActiveStorage::Downloader#open'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/downloader.rb:24:in 'ActiveStorage::Downloader#open_tempfile'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/downloader.rb:12:in 'ActiveStorage::Downloader#open'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/service.rb:92:in 'ActiveStorage::Service#open'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/app/models/active_storage/blob.rb:310:in 'ActiveStorage::Blob#open'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/analyzer.rb:35:in 'ActiveStorage::Analyzer#download_blob_to_tempfile'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/analyzer/image_analyzer/vips.rb:20:in 'ActiveStorage::Analyzer::ImageAnalyzer::Vips#read_image'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/analyzer/image_analyzer.rb:25:in 'ActiveStorage::Analyzer::ImageAnalyzer#metadata'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/app/models/active_storage/blob/analyzable.rb:52:in 'ActiveStorage::Blob::Analyzable#extract_metadata_via_analyzer'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/app/models/active_storage/blob/analyzable.rb:30:in 'ActiveStorage::Blob::Analyzable#analyze'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/app/jobs/active_storage/analyze_job.rb:11:in 'ActiveStorage::AnalyzeJob#perform'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/execution.rb:68:in 'block in ActiveJob::Execution#_perform_job'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/callbacks.rb:101:in 'ActiveSupport::Callbacks#run_callbacks'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/execution.rb:67:in 'ActiveJob::Execution#_perform_job'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/instrumentation.rb:44:in 'ActiveJob::Instrumentation#_perform_job'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/execution.rb:51:in 'ActiveJob::Execution#perform_now'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/instrumentation.rb:26:in 'block in ActiveJob::Instrumentation#perform_now'","/usr/local/bundle/ruby/3.4.0/gems/activerecord-8.1.3.1/lib/active_record/railties/job_runtime.rb:12:in 'block in ActiveRecord::Railties::JobRuntime#instrument'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/instrumentation.rb:34:in 'block in ActiveJob::Instrumentation#instrument'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/notifications.rb:210:in 'block in ActiveSupport::Notifications.instrument'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/notifications/instrumenter.rb:58:in 'ActiveSupport::Notifications::Instrumenter#instrument'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/notifications.rb:210:in 'ActiveSupport::Notifications.instrument'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/instrumentation.rb:33:in 'ActiveJob::Instrumentation#instrument'","/usr/local/bundle/ruby/3.4.0/gems/activerecord-8.1.3.1/lib/active_record/railties/job_runtime.rb:10:in 'ActiveRecord::Railties::JobRuntime#instrument'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/instrumentation.rb:26:in 'ActiveJob::Instrumentation#perform_now'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/logging.rb:32:in 'block in ActiveJob::Logging#perform_now'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/tagged_logging.rb:143:in 'block in ActiveSupport::TaggedLogging#tagged'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/tagged_logging.rb:38:in 'ActiveSupport::TaggedLogging::Formatter#tagged'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/tagged_logging.rb:143:in 'ActiveSupport::TaggedLogging#tagged'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/broadcast_logger.rb:228:in 'ActiveSupport::BroadcastLogger#method_missing'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/logging.rb:39:in 'ActiveJob::Logging#tag_logger'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/logging.rb:32:in 'ActiveJob::Logging#perform_now'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/execution_state.rb:7:in 'block (2 levels) in ActiveJob::ExecutionState#perform_now'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/core_ext/time/zones.rb:65:in 'Time.use_zone'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/execution_state.rb:7:in 'block in ActiveJob::ExecutionState#perform_now'","/usr/local/bundle/ruby/3.4.0/gems/i18n-1.15.2/lib/i18n.rb:383:in 'I18n::Base#with_locale'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/execution_state.rb:6:in 'ActiveJob::ExecutionState#perform_now'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/execution.rb:29:in 'block in ActiveJob::Execution::ClassMethods#execute'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/callbacks.rb:121:in 'block in ActiveSupport::Callbacks#run_callbacks'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/railtie.rb:86:in 'block (4 levels) in \\u003cclass:Railtie\\u003e'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/reloader.rb:77:in 'block in ActiveSupport::Reloader.wrap'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/execution_wrapper.rb:87:in 'ActiveSupport::ExecutionWrapper.wrap'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/reloader.rb:74:in 'ActiveSupport::Reloader.wrap'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/railtie.rb:85:in 'block (3 levels) in \\u003cclass:Railtie\\u003e'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/callbacks.rb:130:in 'BasicObject#instance_exec'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/callbacks.rb:130:in 'block in ActiveSupport::Callbacks#run_callbacks'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/callbacks.rb:141:in 'ActiveSupport::Callbacks#run_callbacks'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/execution.rb:27:in 'ActiveJob::Execution::ClassMethods#execute'","/usr/local/bundle/ruby/3.4.0/gems/solid_queue-1.7.0/app/models/solid_queue/claimed_execution.rb:95:in 'SolidQueue::ClaimedExecution#execute'","/usr/local/bundle/ruby/3.4.0/gems/solid_queue-1.7.0/app/models/solid_queue/claimed_execution.rb:66:in 'SolidQueue::ClaimedExecution#perform'","/usr/local/bundle/ruby/3.4.0/gems/solid_queue-1.7.0/lib/solid_queue/pool.rb:51:in 'block in SolidQueue::Pool#perform_execution'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/execution_wrapper.rb:91:in 'ActiveSupport::ExecutionWrapper.wrap'","/usr/local/bundle/ruby/3.4.0/gems/solid_queue-1.7.0/lib/solid_queue/app_executor.rb:7:in 'SolidQueue::AppExecutor#wrap_in_app_executor'","/usr/local/bundle/ruby/3.4.0/gems/solid_queue-1.7.0/lib/solid_queue/pool.rb:51:in 'SolidQueue::Pool#perform_execution'","/usr/local/bundle/ruby/3.4.0/gems/solid_queue-1.7.0/lib/solid_queue/thread_pool.rb:16:in 'block in SolidQueue::ThreadPool#schedule'","/usr/local/bundle/ruby/3.4.0/gems/concurrent-ruby-1.3.8/lib/concurrent-ruby/concurrent/promises.rb:1599:in 'Concurrent::Promises::AbstractPromise#evaluate_to'","/usr/local/bundle/ruby/3.4.0/gems/concurrent-ruby-1.3.8/lib/concurrent-ruby/concurrent/promises.rb:1782:in 'block in Concurrent::Promises::ChainPromise#on_resolvable'","/usr/local/bundle/ruby/3.4.0/gems/concurrent-ruby-1.3.8/lib/concurrent-ruby/concurrent/executor/ruby_thread_pool_executor.rb:382:in 'Concurrent::RubyThreadPoolExecutor::Worker#run_task'","/usr/local/bundle/ruby/3.4.0/gems/concurrent-ruby-1.3.8/lib/concurrent-ruby/concurrent/executor/ruby_thread_pool_executor.rb:372:in 'block (3 levels) in Concurrent::RubyThreadPoolExecutor::Worker#create_worker'","\\u003cinternal:kernel\\u003e:168:in 'Kernel#loop'","/usr/local/bundle/ruby/3.4.0/gems/concurrent-ruby-1.3.8/lib/concurrent-ruby/concurrent/executor/ruby_thread_pool_executor.rb:361:in 'block (2 levels) in Concurrent::RubyThreadPoolExecutor::Worker#create_worker'","/usr/local/bundle/ruby/3.4.0/gems/concurrent-ruby-1.3.8/lib/concurrent-ruby/concurrent/executor/ruby_thread_pool_executor.rb:358:in 'Kernel#catch'","/usr/local/bundle/ruby/3.4.0/gems/concurrent-ruby-1.3.8/lib/concurrent-ruby/concurrent/executor/ruby_thread_pool_executor.rb:358:in 'block in Concurrent::RubyThreadPoolExecutor::Worker#create_worker'"]}	2026-09-11 15:35:28.849826
5	209	{"exception_class":"ActiveStorage::FileNotFoundError","message":"ActiveStorage::FileNotFoundError","backtrace":["/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/service/disk_service.rb:192:in 'ActiveStorage::Service::DiskService#stream'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/service/disk_service.rb:31:in 'block in ActiveStorage::Service::DiskService#download'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/notifications.rb:210:in 'block in ActiveSupport::Notifications.instrument'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/notifications/instrumenter.rb:58:in 'ActiveSupport::Notifications::Instrumenter#instrument'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/notifications.rb:210:in 'ActiveSupport::Notifications.instrument'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/service.rb:169:in 'ActiveStorage::Service#instrument'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/service/disk_service.rb:30:in 'ActiveStorage::Service::DiskService#download'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/downloader.rb:32:in 'ActiveStorage::Downloader#download'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/downloader.rb:13:in 'block in ActiveStorage::Downloader#open'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/downloader.rb:24:in 'ActiveStorage::Downloader#open_tempfile'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/downloader.rb:12:in 'ActiveStorage::Downloader#open'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/service.rb:92:in 'ActiveStorage::Service#open'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/app/models/active_storage/blob.rb:310:in 'ActiveStorage::Blob#open'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/analyzer.rb:35:in 'ActiveStorage::Analyzer#download_blob_to_tempfile'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/analyzer/image_analyzer/vips.rb:20:in 'ActiveStorage::Analyzer::ImageAnalyzer::Vips#read_image'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/analyzer/image_analyzer.rb:25:in 'ActiveStorage::Analyzer::ImageAnalyzer#metadata'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/app/models/active_storage/blob/analyzable.rb:52:in 'ActiveStorage::Blob::Analyzable#extract_metadata_via_analyzer'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/app/models/active_storage/blob/analyzable.rb:30:in 'ActiveStorage::Blob::Analyzable#analyze'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/app/jobs/active_storage/analyze_job.rb:11:in 'ActiveStorage::AnalyzeJob#perform'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/execution.rb:68:in 'block in ActiveJob::Execution#_perform_job'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/callbacks.rb:101:in 'ActiveSupport::Callbacks#run_callbacks'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/execution.rb:67:in 'ActiveJob::Execution#_perform_job'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/instrumentation.rb:44:in 'ActiveJob::Instrumentation#_perform_job'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/execution.rb:51:in 'ActiveJob::Execution#perform_now'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/instrumentation.rb:26:in 'block in ActiveJob::Instrumentation#perform_now'","/usr/local/bundle/ruby/3.4.0/gems/activerecord-8.1.3.1/lib/active_record/railties/job_runtime.rb:12:in 'block in ActiveRecord::Railties::JobRuntime#instrument'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/instrumentation.rb:34:in 'block in ActiveJob::Instrumentation#instrument'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/notifications.rb:210:in 'block in ActiveSupport::Notifications.instrument'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/notifications/instrumenter.rb:58:in 'ActiveSupport::Notifications::Instrumenter#instrument'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/notifications.rb:210:in 'ActiveSupport::Notifications.instrument'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/instrumentation.rb:33:in 'ActiveJob::Instrumentation#instrument'","/usr/local/bundle/ruby/3.4.0/gems/activerecord-8.1.3.1/lib/active_record/railties/job_runtime.rb:10:in 'ActiveRecord::Railties::JobRuntime#instrument'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/instrumentation.rb:26:in 'ActiveJob::Instrumentation#perform_now'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/logging.rb:32:in 'block in ActiveJob::Logging#perform_now'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/tagged_logging.rb:143:in 'block in ActiveSupport::TaggedLogging#tagged'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/tagged_logging.rb:38:in 'ActiveSupport::TaggedLogging::Formatter#tagged'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/tagged_logging.rb:143:in 'ActiveSupport::TaggedLogging#tagged'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/broadcast_logger.rb:228:in 'ActiveSupport::BroadcastLogger#method_missing'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/logging.rb:39:in 'ActiveJob::Logging#tag_logger'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/logging.rb:32:in 'ActiveJob::Logging#perform_now'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/execution_state.rb:7:in 'block (2 levels) in ActiveJob::ExecutionState#perform_now'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/core_ext/time/zones.rb:65:in 'Time.use_zone'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/execution_state.rb:7:in 'block in ActiveJob::ExecutionState#perform_now'","/usr/local/bundle/ruby/3.4.0/gems/i18n-1.15.2/lib/i18n.rb:383:in 'I18n::Base#with_locale'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/execution_state.rb:6:in 'ActiveJob::ExecutionState#perform_now'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/execution.rb:29:in 'block in ActiveJob::Execution::ClassMethods#execute'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/callbacks.rb:121:in 'block in ActiveSupport::Callbacks#run_callbacks'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/railtie.rb:86:in 'block (4 levels) in \\u003cclass:Railtie\\u003e'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/reloader.rb:77:in 'block in ActiveSupport::Reloader.wrap'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/execution_wrapper.rb:87:in 'ActiveSupport::ExecutionWrapper.wrap'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/reloader.rb:74:in 'ActiveSupport::Reloader.wrap'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/railtie.rb:85:in 'block (3 levels) in \\u003cclass:Railtie\\u003e'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/callbacks.rb:130:in 'BasicObject#instance_exec'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/callbacks.rb:130:in 'block in ActiveSupport::Callbacks#run_callbacks'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/callbacks.rb:141:in 'ActiveSupport::Callbacks#run_callbacks'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/execution.rb:27:in 'ActiveJob::Execution::ClassMethods#execute'","/usr/local/bundle/ruby/3.4.0/gems/solid_queue-1.7.0/app/models/solid_queue/claimed_execution.rb:95:in 'SolidQueue::ClaimedExecution#execute'","/usr/local/bundle/ruby/3.4.0/gems/solid_queue-1.7.0/app/models/solid_queue/claimed_execution.rb:66:in 'SolidQueue::ClaimedExecution#perform'","/usr/local/bundle/ruby/3.4.0/gems/solid_queue-1.7.0/lib/solid_queue/pool.rb:51:in 'block in SolidQueue::Pool#perform_execution'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/execution_wrapper.rb:91:in 'ActiveSupport::ExecutionWrapper.wrap'","/usr/local/bundle/ruby/3.4.0/gems/solid_queue-1.7.0/lib/solid_queue/app_executor.rb:7:in 'SolidQueue::AppExecutor#wrap_in_app_executor'","/usr/local/bundle/ruby/3.4.0/gems/solid_queue-1.7.0/lib/solid_queue/pool.rb:51:in 'SolidQueue::Pool#perform_execution'","/usr/local/bundle/ruby/3.4.0/gems/solid_queue-1.7.0/lib/solid_queue/thread_pool.rb:16:in 'block in SolidQueue::ThreadPool#schedule'","/usr/local/bundle/ruby/3.4.0/gems/concurrent-ruby-1.3.8/lib/concurrent-ruby/concurrent/promises.rb:1599:in 'Concurrent::Promises::AbstractPromise#evaluate_to'","/usr/local/bundle/ruby/3.4.0/gems/concurrent-ruby-1.3.8/lib/concurrent-ruby/concurrent/promises.rb:1782:in 'block in Concurrent::Promises::ChainPromise#on_resolvable'","/usr/local/bundle/ruby/3.4.0/gems/concurrent-ruby-1.3.8/lib/concurrent-ruby/concurrent/executor/ruby_thread_pool_executor.rb:382:in 'Concurrent::RubyThreadPoolExecutor::Worker#run_task'","/usr/local/bundle/ruby/3.4.0/gems/concurrent-ruby-1.3.8/lib/concurrent-ruby/concurrent/executor/ruby_thread_pool_executor.rb:372:in 'block (3 levels) in Concurrent::RubyThreadPoolExecutor::Worker#create_worker'","\\u003cinternal:kernel\\u003e:168:in 'Kernel#loop'","/usr/local/bundle/ruby/3.4.0/gems/concurrent-ruby-1.3.8/lib/concurrent-ruby/concurrent/executor/ruby_thread_pool_executor.rb:361:in 'block (2 levels) in Concurrent::RubyThreadPoolExecutor::Worker#create_worker'","/usr/local/bundle/ruby/3.4.0/gems/concurrent-ruby-1.3.8/lib/concurrent-ruby/concurrent/executor/ruby_thread_pool_executor.rb:358:in 'Kernel#catch'","/usr/local/bundle/ruby/3.4.0/gems/concurrent-ruby-1.3.8/lib/concurrent-ruby/concurrent/executor/ruby_thread_pool_executor.rb:358:in 'block in Concurrent::RubyThreadPoolExecutor::Worker#create_worker'"]}	2026-09-12 16:31:29.812357
6	213	{"exception_class":"ActiveStorage::FileNotFoundError","message":"ActiveStorage::FileNotFoundError","backtrace":["/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/service/disk_service.rb:192:in 'ActiveStorage::Service::DiskService#stream'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/service/disk_service.rb:31:in 'block in ActiveStorage::Service::DiskService#download'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/notifications.rb:210:in 'block in ActiveSupport::Notifications.instrument'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/notifications/instrumenter.rb:58:in 'ActiveSupport::Notifications::Instrumenter#instrument'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/notifications.rb:210:in 'ActiveSupport::Notifications.instrument'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/service.rb:169:in 'ActiveStorage::Service#instrument'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/service/disk_service.rb:30:in 'ActiveStorage::Service::DiskService#download'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/downloader.rb:32:in 'ActiveStorage::Downloader#download'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/downloader.rb:13:in 'block in ActiveStorage::Downloader#open'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/downloader.rb:24:in 'ActiveStorage::Downloader#open_tempfile'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/downloader.rb:12:in 'ActiveStorage::Downloader#open'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/service.rb:92:in 'ActiveStorage::Service#open'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/app/models/active_storage/blob.rb:310:in 'ActiveStorage::Blob#open'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/analyzer.rb:35:in 'ActiveStorage::Analyzer#download_blob_to_tempfile'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/analyzer/image_analyzer/vips.rb:20:in 'ActiveStorage::Analyzer::ImageAnalyzer::Vips#read_image'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/analyzer/image_analyzer.rb:25:in 'ActiveStorage::Analyzer::ImageAnalyzer#metadata'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/app/models/active_storage/blob/analyzable.rb:52:in 'ActiveStorage::Blob::Analyzable#extract_metadata_via_analyzer'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/app/models/active_storage/blob/analyzable.rb:30:in 'ActiveStorage::Blob::Analyzable#analyze'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/app/jobs/active_storage/analyze_job.rb:11:in 'ActiveStorage::AnalyzeJob#perform'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/execution.rb:68:in 'block in ActiveJob::Execution#_perform_job'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/callbacks.rb:101:in 'ActiveSupport::Callbacks#run_callbacks'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/execution.rb:67:in 'ActiveJob::Execution#_perform_job'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/instrumentation.rb:44:in 'ActiveJob::Instrumentation#_perform_job'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/execution.rb:51:in 'ActiveJob::Execution#perform_now'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/instrumentation.rb:26:in 'block in ActiveJob::Instrumentation#perform_now'","/usr/local/bundle/ruby/3.4.0/gems/activerecord-8.1.3.1/lib/active_record/railties/job_runtime.rb:12:in 'block in ActiveRecord::Railties::JobRuntime#instrument'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/instrumentation.rb:34:in 'block in ActiveJob::Instrumentation#instrument'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/notifications.rb:210:in 'block in ActiveSupport::Notifications.instrument'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/notifications/instrumenter.rb:58:in 'ActiveSupport::Notifications::Instrumenter#instrument'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/notifications.rb:210:in 'ActiveSupport::Notifications.instrument'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/instrumentation.rb:33:in 'ActiveJob::Instrumentation#instrument'","/usr/local/bundle/ruby/3.4.0/gems/activerecord-8.1.3.1/lib/active_record/railties/job_runtime.rb:10:in 'ActiveRecord::Railties::JobRuntime#instrument'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/instrumentation.rb:26:in 'ActiveJob::Instrumentation#perform_now'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/logging.rb:32:in 'block in ActiveJob::Logging#perform_now'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/tagged_logging.rb:143:in 'block in ActiveSupport::TaggedLogging#tagged'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/tagged_logging.rb:38:in 'ActiveSupport::TaggedLogging::Formatter#tagged'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/tagged_logging.rb:143:in 'ActiveSupport::TaggedLogging#tagged'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/broadcast_logger.rb:228:in 'ActiveSupport::BroadcastLogger#method_missing'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/logging.rb:39:in 'ActiveJob::Logging#tag_logger'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/logging.rb:32:in 'ActiveJob::Logging#perform_now'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/execution_state.rb:7:in 'block (2 levels) in ActiveJob::ExecutionState#perform_now'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/core_ext/time/zones.rb:65:in 'Time.use_zone'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/execution_state.rb:7:in 'block in ActiveJob::ExecutionState#perform_now'","/usr/local/bundle/ruby/3.4.0/gems/i18n-1.15.2/lib/i18n.rb:383:in 'I18n::Base#with_locale'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/execution_state.rb:6:in 'ActiveJob::ExecutionState#perform_now'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/execution.rb:29:in 'block in ActiveJob::Execution::ClassMethods#execute'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/callbacks.rb:121:in 'block in ActiveSupport::Callbacks#run_callbacks'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/railtie.rb:86:in 'block (4 levels) in \\u003cclass:Railtie\\u003e'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/reloader.rb:77:in 'block in ActiveSupport::Reloader.wrap'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/execution_wrapper.rb:87:in 'ActiveSupport::ExecutionWrapper.wrap'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/reloader.rb:74:in 'ActiveSupport::Reloader.wrap'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/railtie.rb:85:in 'block (3 levels) in \\u003cclass:Railtie\\u003e'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/callbacks.rb:130:in 'BasicObject#instance_exec'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/callbacks.rb:130:in 'block in ActiveSupport::Callbacks#run_callbacks'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/callbacks.rb:141:in 'ActiveSupport::Callbacks#run_callbacks'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/execution.rb:27:in 'ActiveJob::Execution::ClassMethods#execute'","/usr/local/bundle/ruby/3.4.0/gems/solid_queue-1.7.0/app/models/solid_queue/claimed_execution.rb:95:in 'SolidQueue::ClaimedExecution#execute'","/usr/local/bundle/ruby/3.4.0/gems/solid_queue-1.7.0/app/models/solid_queue/claimed_execution.rb:66:in 'SolidQueue::ClaimedExecution#perform'","/usr/local/bundle/ruby/3.4.0/gems/solid_queue-1.7.0/lib/solid_queue/pool.rb:51:in 'block in SolidQueue::Pool#perform_execution'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/execution_wrapper.rb:91:in 'ActiveSupport::ExecutionWrapper.wrap'","/usr/local/bundle/ruby/3.4.0/gems/solid_queue-1.7.0/lib/solid_queue/app_executor.rb:7:in 'SolidQueue::AppExecutor#wrap_in_app_executor'","/usr/local/bundle/ruby/3.4.0/gems/solid_queue-1.7.0/lib/solid_queue/pool.rb:51:in 'SolidQueue::Pool#perform_execution'","/usr/local/bundle/ruby/3.4.0/gems/solid_queue-1.7.0/lib/solid_queue/thread_pool.rb:16:in 'block in SolidQueue::ThreadPool#schedule'","/usr/local/bundle/ruby/3.4.0/gems/concurrent-ruby-1.3.8/lib/concurrent-ruby/concurrent/promises.rb:1599:in 'Concurrent::Promises::AbstractPromise#evaluate_to'","/usr/local/bundle/ruby/3.4.0/gems/concurrent-ruby-1.3.8/lib/concurrent-ruby/concurrent/promises.rb:1782:in 'block in Concurrent::Promises::ChainPromise#on_resolvable'","/usr/local/bundle/ruby/3.4.0/gems/concurrent-ruby-1.3.8/lib/concurrent-ruby/concurrent/executor/ruby_thread_pool_executor.rb:382:in 'Concurrent::RubyThreadPoolExecutor::Worker#run_task'","/usr/local/bundle/ruby/3.4.0/gems/concurrent-ruby-1.3.8/lib/concurrent-ruby/concurrent/executor/ruby_thread_pool_executor.rb:372:in 'block (3 levels) in Concurrent::RubyThreadPoolExecutor::Worker#create_worker'","\\u003cinternal:kernel\\u003e:168:in 'Kernel#loop'","/usr/local/bundle/ruby/3.4.0/gems/concurrent-ruby-1.3.8/lib/concurrent-ruby/concurrent/executor/ruby_thread_pool_executor.rb:361:in 'block (2 levels) in Concurrent::RubyThreadPoolExecutor::Worker#create_worker'","/usr/local/bundle/ruby/3.4.0/gems/concurrent-ruby-1.3.8/lib/concurrent-ruby/concurrent/executor/ruby_thread_pool_executor.rb:358:in 'Kernel#catch'","/usr/local/bundle/ruby/3.4.0/gems/concurrent-ruby-1.3.8/lib/concurrent-ruby/concurrent/executor/ruby_thread_pool_executor.rb:358:in 'block in Concurrent::RubyThreadPoolExecutor::Worker#create_worker'"]}	2026-09-12 18:27:18.393836
7	340	{"exception_class":"ActiveStorage::FileNotFoundError","message":"ActiveStorage::FileNotFoundError","backtrace":["/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/service/disk_service.rb:192:in 'ActiveStorage::Service::DiskService#stream'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/service/disk_service.rb:31:in 'block in ActiveStorage::Service::DiskService#download'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/notifications.rb:210:in 'block in ActiveSupport::Notifications.instrument'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/notifications/instrumenter.rb:58:in 'ActiveSupport::Notifications::Instrumenter#instrument'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/notifications.rb:210:in 'ActiveSupport::Notifications.instrument'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/service.rb:169:in 'ActiveStorage::Service#instrument'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/service/disk_service.rb:30:in 'ActiveStorage::Service::DiskService#download'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/downloader.rb:32:in 'ActiveStorage::Downloader#download'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/downloader.rb:13:in 'block in ActiveStorage::Downloader#open'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/downloader.rb:24:in 'ActiveStorage::Downloader#open_tempfile'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/downloader.rb:12:in 'ActiveStorage::Downloader#open'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/service.rb:92:in 'ActiveStorage::Service#open'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/app/models/active_storage/blob.rb:310:in 'ActiveStorage::Blob#open'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/analyzer.rb:35:in 'ActiveStorage::Analyzer#download_blob_to_tempfile'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/analyzer/image_analyzer/vips.rb:20:in 'ActiveStorage::Analyzer::ImageAnalyzer::Vips#read_image'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/lib/active_storage/analyzer/image_analyzer.rb:25:in 'ActiveStorage::Analyzer::ImageAnalyzer#metadata'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/app/models/active_storage/blob/analyzable.rb:52:in 'ActiveStorage::Blob::Analyzable#extract_metadata_via_analyzer'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/app/models/active_storage/blob/analyzable.rb:30:in 'ActiveStorage::Blob::Analyzable#analyze'","/usr/local/bundle/ruby/3.4.0/gems/activestorage-8.1.3.1/app/jobs/active_storage/analyze_job.rb:11:in 'ActiveStorage::AnalyzeJob#perform'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/execution.rb:68:in 'block in ActiveJob::Execution#_perform_job'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/callbacks.rb:101:in 'ActiveSupport::Callbacks#run_callbacks'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/execution.rb:67:in 'ActiveJob::Execution#_perform_job'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/instrumentation.rb:44:in 'ActiveJob::Instrumentation#_perform_job'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/execution.rb:51:in 'ActiveJob::Execution#perform_now'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/instrumentation.rb:26:in 'block in ActiveJob::Instrumentation#perform_now'","/usr/local/bundle/ruby/3.4.0/gems/activerecord-8.1.3.1/lib/active_record/railties/job_runtime.rb:12:in 'block in ActiveRecord::Railties::JobRuntime#instrument'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/instrumentation.rb:34:in 'block in ActiveJob::Instrumentation#instrument'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/notifications.rb:210:in 'block in ActiveSupport::Notifications.instrument'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/notifications/instrumenter.rb:58:in 'ActiveSupport::Notifications::Instrumenter#instrument'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/notifications.rb:210:in 'ActiveSupport::Notifications.instrument'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/instrumentation.rb:33:in 'ActiveJob::Instrumentation#instrument'","/usr/local/bundle/ruby/3.4.0/gems/activerecord-8.1.3.1/lib/active_record/railties/job_runtime.rb:10:in 'ActiveRecord::Railties::JobRuntime#instrument'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/instrumentation.rb:26:in 'ActiveJob::Instrumentation#perform_now'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/logging.rb:32:in 'block in ActiveJob::Logging#perform_now'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/tagged_logging.rb:143:in 'block in ActiveSupport::TaggedLogging#tagged'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/tagged_logging.rb:38:in 'ActiveSupport::TaggedLogging::Formatter#tagged'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/tagged_logging.rb:143:in 'ActiveSupport::TaggedLogging#tagged'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/broadcast_logger.rb:228:in 'ActiveSupport::BroadcastLogger#method_missing'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/logging.rb:39:in 'ActiveJob::Logging#tag_logger'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/logging.rb:32:in 'ActiveJob::Logging#perform_now'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/execution_state.rb:7:in 'block (2 levels) in ActiveJob::ExecutionState#perform_now'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/core_ext/time/zones.rb:65:in 'Time.use_zone'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/execution_state.rb:7:in 'block in ActiveJob::ExecutionState#perform_now'","/usr/local/bundle/ruby/3.4.0/gems/i18n-1.15.2/lib/i18n.rb:383:in 'I18n::Base#with_locale'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/execution_state.rb:6:in 'ActiveJob::ExecutionState#perform_now'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/execution.rb:29:in 'block in ActiveJob::Execution::ClassMethods#execute'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/callbacks.rb:121:in 'block in ActiveSupport::Callbacks#run_callbacks'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/railtie.rb:86:in 'block (4 levels) in \\u003cclass:Railtie\\u003e'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/reloader.rb:77:in 'block in ActiveSupport::Reloader.wrap'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/execution_wrapper.rb:87:in 'ActiveSupport::ExecutionWrapper.wrap'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/reloader.rb:74:in 'ActiveSupport::Reloader.wrap'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/railtie.rb:85:in 'block (3 levels) in \\u003cclass:Railtie\\u003e'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/callbacks.rb:130:in 'BasicObject#instance_exec'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/callbacks.rb:130:in 'block in ActiveSupport::Callbacks#run_callbacks'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/callbacks.rb:141:in 'ActiveSupport::Callbacks#run_callbacks'","/usr/local/bundle/ruby/3.4.0/gems/activejob-8.1.3.1/lib/active_job/execution.rb:27:in 'ActiveJob::Execution::ClassMethods#execute'","/usr/local/bundle/ruby/3.4.0/gems/solid_queue-1.7.0/app/models/solid_queue/claimed_execution.rb:95:in 'SolidQueue::ClaimedExecution#execute'","/usr/local/bundle/ruby/3.4.0/gems/solid_queue-1.7.0/app/models/solid_queue/claimed_execution.rb:66:in 'SolidQueue::ClaimedExecution#perform'","/usr/local/bundle/ruby/3.4.0/gems/solid_queue-1.7.0/lib/solid_queue/pool.rb:51:in 'block in SolidQueue::Pool#perform_execution'","/usr/local/bundle/ruby/3.4.0/gems/activesupport-8.1.3.1/lib/active_support/execution_wrapper.rb:91:in 'ActiveSupport::ExecutionWrapper.wrap'","/usr/local/bundle/ruby/3.4.0/gems/solid_queue-1.7.0/lib/solid_queue/app_executor.rb:7:in 'SolidQueue::AppExecutor#wrap_in_app_executor'","/usr/local/bundle/ruby/3.4.0/gems/solid_queue-1.7.0/lib/solid_queue/pool.rb:51:in 'SolidQueue::Pool#perform_execution'","/usr/local/bundle/ruby/3.4.0/gems/solid_queue-1.7.0/lib/solid_queue/thread_pool.rb:16:in 'block in SolidQueue::ThreadPool#schedule'","/usr/local/bundle/ruby/3.4.0/gems/concurrent-ruby-1.3.8/lib/concurrent-ruby/concurrent/promises.rb:1599:in 'Concurrent::Promises::AbstractPromise#evaluate_to'","/usr/local/bundle/ruby/3.4.0/gems/concurrent-ruby-1.3.8/lib/concurrent-ruby/concurrent/promises.rb:1782:in 'block in Concurrent::Promises::ChainPromise#on_resolvable'","/usr/local/bundle/ruby/3.4.0/gems/concurrent-ruby-1.3.8/lib/concurrent-ruby/concurrent/executor/ruby_thread_pool_executor.rb:382:in 'Concurrent::RubyThreadPoolExecutor::Worker#run_task'","/usr/local/bundle/ruby/3.4.0/gems/concurrent-ruby-1.3.8/lib/concurrent-ruby/concurrent/executor/ruby_thread_pool_executor.rb:372:in 'block (3 levels) in Concurrent::RubyThreadPoolExecutor::Worker#create_worker'","\\u003cinternal:kernel\\u003e:168:in 'Kernel#loop'","/usr/local/bundle/ruby/3.4.0/gems/concurrent-ruby-1.3.8/lib/concurrent-ruby/concurrent/executor/ruby_thread_pool_executor.rb:361:in 'block (2 levels) in Concurrent::RubyThreadPoolExecutor::Worker#create_worker'","/usr/local/bundle/ruby/3.4.0/gems/concurrent-ruby-1.3.8/lib/concurrent-ruby/concurrent/executor/ruby_thread_pool_executor.rb:358:in 'Kernel#catch'","/usr/local/bundle/ruby/3.4.0/gems/concurrent-ruby-1.3.8/lib/concurrent-ruby/concurrent/executor/ruby_thread_pool_executor.rb:358:in 'block in Concurrent::RubyThreadPoolExecutor::Worker#create_worker'"]}	2026-09-17 18:41:22.471478
\.


--
-- Data for Name: solid_queue_pauses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."solid_queue_pauses" ("id", "queue_name", "created_at") FROM stdin;
\.


--
-- Data for Name: solid_queue_processes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."solid_queue_processes" ("id", "kind", "last_heartbeat_at", "supervisor_id", "pid", "hostname", "metadata", "created_at", "name") FROM stdin;
274	Scheduler	2026-09-23 16:31:42.874292	271	35	8d2275cdff59	{"recurring_schedule":["sync_football_knockout_brackets","clear_solid_queue_finished_jobs"]}	2026-09-17 18:25:20.932294	scheduler-84dc2c582e8ddf9b5d35
273	Dispatcher	2026-09-23 16:31:59.627361	271	18	8d2275cdff59	{"polling_interval":1,"batch_size":500,"concurrency_maintenance_interval":600,"batch_maintenance":true}	2026-09-17 18:25:20.902658	dispatcher-580c39db071807ac98e9
271	Supervisor(fork)	2026-09-23 16:32:13.016788	\N	7	8d2275cdff59	\N	2026-09-17 18:25:20.545366	supervisor(fork)-82a6a65b058e7ae854b9
272	Worker	2026-09-23 16:32:21.382596	271	23	8d2275cdff59	{"polling_interval":1,"queues":"*","pool_type":"thread","pool_size":3}	2026-09-17 18:25:20.91094	worker-3e3a24d58e9953c89446
275	Worker	2026-09-23 16:32:42.965843	271	4387	8d2275cdff59	{"polling_interval":1,"queues":"*","pool_type":"thread","pool_size":3}	2026-09-23 16:32:44.391618	worker-483dac70994cecf6adbb
276	Dispatcher	2026-09-23 16:32:48.765659	271	4404	8d2275cdff59	{"polling_interval":1,"batch_size":500,"concurrency_maintenance_interval":600,"batch_maintenance":true}	2026-09-23 16:32:48.785766	dispatcher-755b5e525af51da1395a
277	Worker	2026-09-23 16:33:12.061981	271	4421	8d2275cdff59	{"polling_interval":1,"queues":"*","pool_type":"thread","pool_size":3}	2026-09-23 16:33:12.299475	worker-da66393def93f107b4cc
278	Dispatcher	2026-09-23 16:33:15.111561	271	4442	8d2275cdff59	{"polling_interval":1,"batch_size":500,"concurrency_maintenance_interval":600,"batch_maintenance":true}	2026-09-23 16:33:15.147247	dispatcher-0ed8181543b782933ee8
279	Dispatcher	2026-09-23 16:33:18.222082	271	4464	8d2275cdff59	{"polling_interval":1,"batch_size":500,"concurrency_maintenance_interval":600,"batch_maintenance":true}	2026-09-23 16:33:18.237376	dispatcher-4ef8cfc707dc45c2679d
280	Dispatcher	2026-09-23 16:33:24.617344	271	4536	8d2275cdff59	{"polling_interval":1,"batch_size":500,"concurrency_maintenance_interval":600,"batch_maintenance":true}	2026-09-23 16:33:24.635491	dispatcher-aca1f989bac54236c921
281	Dispatcher	2026-09-23 16:33:29.889397	271	4583	8d2275cdff59	{"polling_interval":1,"batch_size":500,"concurrency_maintenance_interval":600,"batch_maintenance":true}	2026-09-23 16:33:29.908019	dispatcher-f28e8162d2cf432fb9f2
\.


--
-- Data for Name: solid_queue_ready_executions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."solid_queue_ready_executions" ("id", "job_id", "queue_name", "priority", "created_at") FROM stdin;
\.


--
-- Data for Name: solid_queue_recurring_executions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."solid_queue_recurring_executions" ("id", "job_id", "task_key", "run_at", "created_at") FROM stdin;
475	488	clear_solid_queue_finished_jobs	2026-09-23 16:12:00	2026-09-23 16:12:00.027052
450	463	clear_solid_queue_finished_jobs	2026-09-22 16:12:00	2026-09-22 16:12:00.022263
451	464	clear_solid_queue_finished_jobs	2026-09-22 17:12:00	2026-09-22 17:12:00.023501
452	465	clear_solid_queue_finished_jobs	2026-09-22 18:12:00	2026-09-22 18:12:00.046994
453	466	clear_solid_queue_finished_jobs	2026-09-22 19:12:00	2026-09-22 19:12:00.03608
454	467	clear_solid_queue_finished_jobs	2026-09-22 20:12:00	2026-09-22 20:12:00.025415
455	468	clear_solid_queue_finished_jobs	2026-09-22 21:12:00	2026-09-22 21:12:00.039694
456	469	clear_solid_queue_finished_jobs	2026-09-22 22:12:00	2026-09-22 22:12:00.026457
457	470	clear_solid_queue_finished_jobs	2026-09-22 23:12:00	2026-09-22 23:12:00.03015
458	471	clear_solid_queue_finished_jobs	2026-09-23 00:12:00	2026-09-23 00:12:00.024622
459	472	clear_solid_queue_finished_jobs	2026-09-23 01:12:00	2026-09-23 01:12:00.026174
460	473	clear_solid_queue_finished_jobs	2026-09-23 02:12:00	2026-09-23 02:12:00.024414
461	474	sync_football_knockout_brackets	2026-09-23 03:00:00	2026-09-23 03:00:00.088543
462	475	clear_solid_queue_finished_jobs	2026-09-23 03:12:00	2026-09-23 03:12:00.035701
463	476	clear_solid_queue_finished_jobs	2026-09-23 04:12:00	2026-09-23 04:12:00.031398
464	477	clear_solid_queue_finished_jobs	2026-09-23 05:12:00	2026-09-23 05:12:00.269197
465	478	clear_solid_queue_finished_jobs	2026-09-23 06:12:00	2026-09-23 06:12:00.046302
466	479	clear_solid_queue_finished_jobs	2026-09-23 07:12:00	2026-09-23 07:12:00.032921
467	480	clear_solid_queue_finished_jobs	2026-09-23 08:12:00	2026-09-23 08:12:00.03494
468	481	clear_solid_queue_finished_jobs	2026-09-23 09:12:00	2026-09-23 09:12:00.030983
469	482	clear_solid_queue_finished_jobs	2026-09-23 10:12:00	2026-09-23 10:12:00.02431
470	483	clear_solid_queue_finished_jobs	2026-09-23 11:12:00	2026-09-23 11:12:00.030826
471	484	clear_solid_queue_finished_jobs	2026-09-23 12:12:00	2026-09-23 12:12:00.0211
472	485	clear_solid_queue_finished_jobs	2026-09-23 13:12:00	2026-09-23 13:12:00.023771
473	486	clear_solid_queue_finished_jobs	2026-09-23 14:12:00	2026-09-23 14:12:00.030102
474	487	clear_solid_queue_finished_jobs	2026-09-23 15:12:00	2026-09-23 15:12:00.024553
\.


--
-- Data for Name: solid_queue_recurring_tasks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."solid_queue_recurring_tasks" ("id", "key", "schedule", "command", "class_name", "arguments", "queue_name", "priority", "static", "description", "created_at", "updated_at") FROM stdin;
35	sync_football_knockout_brackets	every day at 3am	\N	SyncFootballKnockoutBracketsJob	\N	default	\N	t	\N	2026-09-10 16:25:01.995831	2026-09-10 16:25:01.995831
36	clear_solid_queue_finished_jobs	every hour at minute 12	SolidQueue::Job.clear_finished_in_batches(sleep_between_batches: 0.3)	\N	\N	\N	\N	t	\N	2026-09-10 16:25:01.995831	2026-09-10 16:25:01.995831
\.


--
-- Data for Name: solid_queue_scheduled_executions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."solid_queue_scheduled_executions" ("id", "job_id", "queue_name", "priority", "scheduled_at", "created_at") FROM stdin;
\.


--
-- Data for Name: solid_queue_semaphores; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."solid_queue_semaphores" ("id", "key", "value", "expires_at", "created_at", "updated_at") FROM stdin;
\.


--
-- Data for Name: standing_rows; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."standing_rows" ("id", "category_id", "championship_id", "created_at", "draws", "goal_diff", "goals_against", "goals_for", "group_key", "losses", "played", "points", "position", "qualified", "team_id", "updated_at", "wins") FROM stdin;
\.


--
-- Data for Name: suspensions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."suspensions" ("id", "athlete_id", "automatic", "category_id", "championship_id", "created_at", "ends_on", "match_event_id", "matches_count", "notes", "reason", "source_data", "source_id", "starts_on", "status", "team_id", "updated_at") FROM stdin;
\.


--
-- Data for Name: team_athletes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."team_athletes" ("id", "athlete_id", "created_at", "source_id", "team_id", "updated_at") FROM stdin;
96	96	2026-09-10 17:05:31.710459	team-athlete-174-96	174	2026-09-10 17:05:31.710459
97	97	2026-09-10 17:05:32.165695	team-athlete-174-97	174	2026-09-10 17:05:32.165695
99	99	2026-09-10 17:05:33.479455	team-athlete-175-99	175	2026-09-10 17:05:33.479455
100	100	2026-09-10 17:05:34.489246	team-athlete-176-100	176	2026-09-10 17:05:34.489246
101	101	2026-09-10 17:05:34.783516	team-athlete-176-101	176	2026-09-10 17:05:34.783516
102	102	2026-09-10 17:05:35.782939	team-athlete-177-102	177	2026-09-10 17:05:35.782939
103	103	2026-09-10 17:05:36.078308	team-athlete-177-103	177	2026-09-10 17:05:36.078308
104	104	2026-09-10 17:05:37.079679	team-athlete-178-104	178	2026-09-10 17:05:37.079679
105	105	2026-09-10 17:05:37.376555	team-athlete-178-105	178	2026-09-10 17:05:37.376555
106	106	2026-09-10 17:05:38.395846	team-athlete-179-106	179	2026-09-10 17:05:38.395846
107	107	2026-09-10 17:05:38.690622	team-athlete-179-107	179	2026-09-10 17:05:38.690622
108	108	2026-09-10 17:05:39.707873	team-athlete-180-108	180	2026-09-10 17:05:39.707873
109	109	2026-09-10 17:05:40.008877	team-athlete-180-109	180	2026-09-10 17:05:40.008877
110	110	2026-09-10 17:05:41.023819	team-athlete-181-110	181	2026-09-10 17:05:41.023819
111	111	2026-09-10 17:05:41.318295	team-athlete-181-111	181	2026-09-10 17:05:41.318295
112	112	2026-09-10 17:05:42.318061	team-athlete-182-112	182	2026-09-10 17:05:42.318061
113	113	2026-09-10 17:05:42.610932	team-athlete-182-113	182	2026-09-10 17:05:42.610932
114	114	2026-09-10 17:05:43.607165	team-athlete-183-114	183	2026-09-10 17:05:43.607165
115	115	2026-09-10 17:05:43.899851	team-athlete-183-115	183	2026-09-10 17:05:43.899851
116	116	2026-09-10 17:05:44.909981	team-athlete-184-116	184	2026-09-10 17:05:44.909981
117	117	2026-09-10 17:05:45.209689	team-athlete-184-117	184	2026-09-10 17:05:45.209689
118	118	2026-09-10 17:05:46.222217	team-athlete-185-118	185	2026-09-10 17:05:46.222217
119	119	2026-09-10 17:05:46.515625	team-athlete-185-119	185	2026-09-10 17:05:46.515625
120	120	2026-09-10 17:05:47.517877	team-athlete-186-120	186	2026-09-10 17:05:47.517877
121	121	2026-09-10 17:05:47.814601	team-athlete-186-121	186	2026-09-10 17:05:47.814601
122	122	2026-09-10 17:05:48.836842	team-athlete-187-122	187	2026-09-10 17:05:48.836842
123	123	2026-09-10 17:05:49.130757	team-athlete-187-123	187	2026-09-10 17:05:49.130757
124	124	2026-09-10 17:05:50.127035	team-athlete-188-124	188	2026-09-10 17:05:50.127035
125	125	2026-09-10 17:05:50.420596	team-athlete-188-125	188	2026-09-10 17:05:50.420596
126	126	2026-09-10 17:05:51.416837	team-athlete-189-126	189	2026-09-10 17:05:51.416837
127	127	2026-09-10 17:05:51.710987	team-athlete-189-127	189	2026-09-10 17:05:51.710987
128	128	2026-09-10 17:05:52.706192	team-athlete-190-128	190	2026-09-10 17:05:52.706192
129	129	2026-09-10 17:05:52.998006	team-athlete-190-129	190	2026-09-10 17:05:52.998006
130	130	2026-09-10 17:05:53.994061	team-athlete-191-130	191	2026-09-10 17:05:53.994061
131	131	2026-09-10 17:05:54.287271	team-athlete-191-131	191	2026-09-10 17:05:54.287271
132	132	2026-09-10 17:05:55.282119	team-athlete-192-132	192	2026-09-10 17:05:55.282119
133	133	2026-09-10 17:05:55.57396	team-athlete-192-133	192	2026-09-10 17:05:55.57396
134	134	2026-09-10 17:05:56.570523	team-athlete-193-134	193	2026-09-10 17:05:56.570523
135	135	2026-09-10 17:05:56.862965	team-athlete-193-135	193	2026-09-10 17:05:56.862965
136	136	2026-09-10 17:05:57.858975	team-athlete-194-136	194	2026-09-10 17:05:57.858975
137	137	2026-09-10 17:05:58.151148	team-athlete-194-137	194	2026-09-10 17:05:58.151148
138	138	2026-09-10 17:05:59.163225	team-athlete-195-138	195	2026-09-10 17:05:59.163225
139	139	2026-09-10 17:05:59.456732	team-athlete-195-139	195	2026-09-10 17:05:59.456732
140	140	2026-09-10 17:06:00.458613	team-athlete-196-140	196	2026-09-10 17:06:00.458613
141	141	2026-09-10 17:06:00.751293	team-athlete-196-141	196	2026-09-10 17:06:00.751293
142	142	2026-09-10 17:06:01.750178	team-athlete-197-142	197	2026-09-10 17:06:01.750178
143	143	2026-09-10 17:06:02.042364	team-athlete-197-143	197	2026-09-10 17:06:02.042364
144	144	2026-09-10 17:06:03.039866	team-athlete-198-144	198	2026-09-10 17:06:03.039866
145	145	2026-09-10 17:06:03.332108	team-athlete-198-145	198	2026-09-10 17:06:03.332108
146	146	2026-09-10 17:06:04.327188	team-athlete-199-146	199	2026-09-10 17:06:04.327188
147	147	2026-09-10 17:06:04.619724	team-athlete-199-147	199	2026-09-10 17:06:04.619724
148	148	2026-09-10 17:06:05.616774	team-athlete-200-148	200	2026-09-10 17:06:05.616774
149	149	2026-09-10 17:06:05.909443	team-athlete-200-149	200	2026-09-10 17:06:05.909443
150	150	2026-09-10 17:06:06.905083	team-athlete-201-150	201	2026-09-10 17:06:06.905083
151	151	2026-09-10 17:06:07.197145	team-athlete-201-151	201	2026-09-10 17:06:07.197145
152	152	2026-09-10 17:06:08.19295	team-athlete-202-152	202	2026-09-10 17:06:08.19295
153	153	2026-09-10 17:06:08.486213	team-athlete-202-153	202	2026-09-10 17:06:08.486213
154	154	2026-09-10 17:06:09.482909	team-athlete-203-154	203	2026-09-10 17:06:09.482909
155	155	2026-09-10 17:06:09.775962	team-athlete-203-155	203	2026-09-10 17:06:09.775962
156	156	2026-09-10 17:06:10.772735	team-athlete-204-156	204	2026-09-10 17:06:10.772735
157	157	2026-09-10 17:06:11.066126	team-athlete-204-157	204	2026-09-10 17:06:11.066126
158	158	2026-09-10 17:06:12.062046	team-athlete-205-158	205	2026-09-10 17:06:12.062046
159	159	2026-09-10 17:06:12.354122	team-athlete-205-159	205	2026-09-10 17:06:12.354122
160	160	2026-09-10 17:06:13.353033	team-athlete-206-160	206	2026-09-10 17:06:13.353033
161	161	2026-09-10 17:06:13.645031	team-athlete-206-161	206	2026-09-10 17:06:13.645031
162	162	2026-09-10 17:06:14.641285	team-athlete-207-162	207	2026-09-10 17:06:14.641285
163	163	2026-09-10 17:06:14.933787	team-athlete-207-163	207	2026-09-10 17:06:14.933787
164	164	2026-09-10 17:06:15.931719	team-athlete-208-164	208	2026-09-10 17:06:15.931719
165	165	2026-09-10 17:06:16.22461	team-athlete-208-165	208	2026-09-10 17:06:16.22461
166	166	2026-09-10 17:06:17.237744	team-athlete-209-166	209	2026-09-10 17:06:17.237744
167	167	2026-09-10 17:06:17.530658	team-athlete-209-167	209	2026-09-10 17:06:17.530658
168	168	2026-09-10 17:06:18.529796	team-athlete-210-168	210	2026-09-10 17:06:18.529796
169	169	2026-09-10 17:06:18.822571	team-athlete-210-169	210	2026-09-10 17:06:18.822571
170	170	2026-09-10 17:06:19.818052	team-athlete-211-170	211	2026-09-10 17:06:19.818052
171	171	2026-09-10 17:06:20.110974	team-athlete-211-171	211	2026-09-10 17:06:20.110974
172	172	2026-09-10 17:06:21.105776	team-athlete-212-172	212	2026-09-10 17:06:21.105776
173	173	2026-09-10 17:06:21.398673	team-athlete-212-173	212	2026-09-10 17:06:21.398673
174	174	2026-09-10 17:06:22.398386	team-athlete-213-174	213	2026-09-10 17:06:22.398386
175	175	2026-09-10 17:06:22.69063	team-athlete-213-175	213	2026-09-10 17:06:22.69063
176	176	2026-09-10 17:06:23.687969	team-athlete-214-176	214	2026-09-10 17:06:23.687969
177	177	2026-09-10 17:06:23.980392	team-athlete-214-177	214	2026-09-10 17:06:23.980392
178	178	2026-09-10 17:06:24.974895	team-athlete-215-178	215	2026-09-10 17:06:24.974895
179	179	2026-09-10 17:06:25.26772	team-athlete-215-179	215	2026-09-10 17:06:25.26772
180	170	2026-09-12 18:04:25.688625	team-athlete-742d6f42	175	2026-09-12 18:04:25.688625
\.


--
-- Data for Name: team_memberships; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."team_memberships" ("id", "created_at", "notes", "role", "source_id", "status", "team_id", "updated_at", "user_id") FROM stdin;
\.


--
-- Data for Name: tranca_duplas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."tranca_duplas" ("id", "category_id", "championship_id", "created_at", "entity_id", "name", "registration_status", "short_name", "source_id", "status", "updated_at") FROM stdin;
118	11	6	2026-09-10 17:05:31.016636	106	Luiza Bianco Checchia / Henrique Tafarelo	aprovada	\N	tranca-import-6-4d6b5c90c0e31808bc62b0e196d480ecca780a095826fe8526797337deb2dcd5	ativo	2026-09-10 17:05:31.016636
121	11	6	2026-09-10 17:05:35.371031	109	Rúbia Mara Cineze / Amélia Maria Orsini Platzeck	aprovada	\N	tranca-import-6-953003ae4b2222f129ce542f8aa873b6b7fd0df76cd047cf43e7d32fd1aafe8e	ativo	2026-09-10 17:05:35.371031
122	11	6	2026-09-10 17:05:36.666352	110	Isis de Aguiar Vallim Lerosa / Dirce Pimentel Levy	aprovada	\N	tranca-import-6-d68d9c5a2f7708af7f1db1bf25da71c3317d4940df70dc2346f6131c8acf40d6	ativo	2026-09-10 17:05:36.666352
123	11	6	2026-09-10 17:05:37.968227	111	Lais Baptista Silva / Tatiana Baptista Silva Zuccari	aprovada	\N	tranca-import-6-a72bea26a8cf9b010c7d53030aa401e42f1c99bd23fcb0cc8a7e142145109323	ativo	2026-09-10 17:05:37.968227
124	11	6	2026-09-10 17:05:39.287715	112	Elzibieta Xenia Krygler Catani / Maria Antonieta Vieira Moss	aprovada	\N	tranca-import-6-e6d168cd05f5ef8a9ad565b10f5fb51a25556062f232c2b82dc0263b048d581a	ativo	2026-09-10 17:05:39.287715
125	11	6	2026-09-10 17:05:40.607685	113	Catharina Parodi / Celia Campagno Cyrino Pereira	aprovada	\N	tranca-import-6-1a35c59ba71e1135ebe98c5e3890d497273e8b1e2e3311a88a02b4874f5d5cfc	ativo	2026-09-10 17:05:40.607685
126	11	6	2026-09-10 17:05:41.904386	114	Laurinda Rocha Tafarello / Virginia de Barros Basto	aprovada	\N	tranca-import-6-40e827a68885f3c5bad3cd2567357517014466f93bfd6fd8c194849291292ac6	ativo	2026-09-10 17:05:41.904386
127	11	6	2026-09-10 17:05:43.197073	115	Marco Antonio Gomes / Rita Rocchiccioli	aprovada	\N	tranca-import-6-65e64c1e3b7c224a93694744f543d72481bd11aa55aea2892fdeffe76a928558	ativo	2026-09-10 17:05:43.197073
128	11	6	2026-09-10 17:05:44.485609	116	Marilena Graziano de A. Barros / Anna Mª Matarazzo Trunkl	aprovada	\N	tranca-import-6-04b0e1fb0bf08b6bf41c7c7431e2b87b40cbd0f5f84883a2efb5aaa4faaa696b	ativo	2026-09-10 17:05:44.485609
129	11	6	2026-09-10 17:05:45.809188	117	Neuza da Rocha F. Mendes / Neide Neli Richter	aprovada	\N	tranca-import-6-7fc7039e8bc6dafe15e74a8d6e5197b8e7c33e1766cad8951be9d358731cfb6e	ativo	2026-09-10 17:05:45.809188
130	11	6	2026-09-10 17:05:47.103775	118	Maria Teresa Lima da Costa / Francesly Sanzi	aprovada	\N	tranca-import-6-56d6211102e63e600b608474429b9dc0456326d7919218dbdced51eef66dbf83	ativo	2026-09-10 17:05:47.103775
131	11	6	2026-09-10 17:05:48.421831	119	Eloísa Maria Amaro / Conceição Pastore de Barros Camargo	aprovada	\N	tranca-import-6-02a7cb629b599f1fbc647756033f9798be59d86148a5bb2d34826f5e5b5be78d	ativo	2026-09-10 17:05:48.421831
132	11	6	2026-09-10 17:05:49.715909	120	Neide Maria de Carvalho / Sérgio Roberto Granieri	aprovada	\N	tranca-import-6-e86e94240cbe912a60e96e86cc3327f8744cf6542a90fd46578088ba5f1fe7ad	ativo	2026-09-10 17:05:49.715909
133	11	6	2026-09-10 17:05:51.005953	121	Vera Regina F. Castro Brandão / Stella Maria de Faria Arduino	aprovada	\N	tranca-import-6-eab4be73a60d5bd3681288517dc85ac227eaf5537c8fd2012fe032fe29f01407	ativo	2026-09-10 17:05:51.005953
135	11	6	2026-09-10 17:05:53.583259	123	Rosana Campi Sophia / Eduardo Luiz Sophia	aprovada	\N	tranca-import-6-35198179812da002f5d118a55c359e35bdd20c93fa976df1d911e889e0cdb8c7	ativo	2026-09-10 17:05:53.583259
136	11	6	2026-09-10 17:05:54.87194	124	Rosa Maria Barone Russo / Claudia M. G. L. Gregorio	aprovada	\N	tranca-import-6-3feab4c9791be2242887ff8ec2abef46c1e5fb5a0c6eb898f992cdde5725f916	ativo	2026-09-10 17:05:54.87194
137	11	6	2026-09-10 17:05:56.160264	125	Eliane Avancini (Lili) / Beatriz Andrade Basile	aprovada	\N	tranca-import-6-465abe9757e2cd5529861cb14ddb16747721040847b6ea9f9a1de5f801ad1794	ativo	2026-09-10 17:05:56.160264
138	11	6	2026-09-10 17:05:57.449155	126	Maria Clara Toledo Fontes / Alice G. Saraiva Dinelli	aprovada	\N	tranca-import-6-55e92b5be52702edf59bfd4e9f421275e6d0f81a7c0080ade4b81fdc39b6ebaa	ativo	2026-09-10 17:05:57.449155
139	11	6	2026-09-10 17:05:58.735326	127	Sonia Regina Maxemiuk Augusto / Anna Mª Bernardini Della	aprovada	\N	tranca-import-6-5c98436f3b80c28c08ef20ec781384b79fdb46fd68d77f06c0c87f9277bb4473	ativo	2026-09-10 17:05:58.735326
140	11	6	2026-09-10 17:06:00.041615	128	Monica de Baptista Medina / Paula Cristina Moreira Pires	aprovada	\N	tranca-import-6-a935db4d5b342a08f04d820dcf9d243d35a250d2ddef11227a3013af9aedf4b6	ativo	2026-09-10 17:06:00.041615
141	11	6	2026-09-10 17:06:01.336615	129	Dárcio M. Falcão / Marlene Martiniano de Azevedo	aprovada	\N	tranca-import-6-06aa32f7aece548e64e5b10b8b4107ed708d638999812f7b71789094056b0347	ativo	2026-09-10 17:06:01.336615
142	11	6	2026-09-10 17:06:02.629064	130	Maria Cecília Loviat / Andiara Maria Roessle Guimarães	aprovada	\N	tranca-import-6-6c755f7a8e27349d6c5869446e8eb3fc4097d5375aeebab61add080c1160f916	ativo	2026-09-10 17:06:02.629064
143	11	6	2026-09-10 17:06:03.9166	131	Eucy Maria Malta Ferreira Cintra de Barros / Marilia Rahal Zorob de Paula Assis	aprovada	\N	tranca-import-6-2dfb2be94c2f296937bad07d72def1bba88cf0972007054903d12a140ceb217f	ativo	2026-09-10 17:06:03.9166
144	11	6	2026-09-10 17:06:05.206715	132	Luís Roberto Leonel de Arruda / Leila Baptista Silva Zuccari	aprovada	\N	tranca-import-6-b7b38d4add6fca4e1722285c078deb6efa27ca8c3234453655e5629bbc96c723	ativo	2026-09-10 17:06:05.206715
145	11	6	2026-09-10 17:06:06.494264	133	Erece Assaf Ricotti / Nilde C. Rainho	aprovada	\N	tranca-import-6-37df6c14f261a87899f751653bcf365357a3ed600734f0a965bd05ffa113e106	ativo	2026-09-10 17:06:06.494264
147	11	6	2026-09-10 17:06:09.072218	135	Luiz Fernando G. de Mello Faro / Fernando Murat de M. Faro	aprovada	\N	tranca-import-6-a7f0e41cde2d83e1c8f68623d22a47228892a3567a9159c7c9aa1be1ac1f251a	ativo	2026-09-10 17:06:09.072218
148	11	6	2026-09-10 17:06:10.361919	136	Leila Bacelar Chicca / Carolina Bacelar Chicca	aprovada	\N	tranca-import-6-833584ca6be32a4794fce0944925f265b84b092cfaec2a9eed060338cfa4e5bb	ativo	2026-09-10 17:06:10.361919
149	11	6	2026-09-10 17:06:11.651788	137	Marcia Regina Bacchin / Gizelle Autran	aprovada	\N	tranca-import-6-fa4c8d82f9804a7e6528155e9e3909a142882be3cab2a8a9e7eed1bd2158d8d6	ativo	2026-09-10 17:06:11.651788
150	11	6	2026-09-10 17:06:12.940375	138	Arnaldo Osse Filho / Glaucia Langbeck Osse	aprovada	\N	tranca-import-6-968089c4b3582fcd1a34c0241995d34362450eda71ee4430434d8a9d9d71cfe2	ativo	2026-09-10 17:06:12.940375
152	11	6	2026-09-10 17:06:15.519062	140	Adriana Braga / Cleusa B Costa	aprovada	\N	tranca-import-6-f1d797a31f9c2628777a72f4236c06d7213d21200a585e26b59e3174084ff49c	ativo	2026-09-10 17:06:15.519062
151	11	6	2026-09-10 17:06:14.231489	139	João Gilberto Pacces / Maria de Lourdes Dal Buono	rejeitada	\N	tranca-import-6-5be0ab3c3f394a96389d1e9ca3860d7d22d8be24dcfc5883dcafac5c3ddca5d8	ativo	2026-09-12 18:01:20.908778
153	11	6	2026-09-10 17:06:16.827989	141	Ana Cecilia F. de Sá Borrelli / Ivan Gonçalves Branco da Silva	rejeitada	\N	tranca-import-6-4124b59fb2ba00dd8e161b7c1b13ce3d6329abc9d7f1083ec368ff80c25b5b0f	ativo	2026-09-12 18:01:51.456339
134	11	6	2026-09-10 17:05:52.295344	122	Claudia Pirani Xande / Beatriz Helena Tess	rejeitada	\N	tranca-import-6-282d86dcc0eaa955711b45b02849a077816d3b828d5078750d55a979f54f4b43	ativo	2026-09-12 18:02:15.333969
120	11	6	2026-09-10 17:05:34.074277	108	Antonio Sérgio Fernandes / Carlos Alberto Pedreschi	rejeitada	\N	tranca-import-6-086f12b12f621d0712ec8485e4f1adeef6193114829a990beb8a7dd5d9f5350a	ativo	2026-09-12 18:02:37.974761
119	11	6	2026-09-10 17:05:32.76646	107	Leon Majer / Maria Helena Serzedo	aprovada	\N	tranca-import-6-cebe7c5dd2775f6a1846b6a6ba48dc34411f5caff8baeb2593b1a8d464137a77	ativo	2026-09-12 18:03:31.45872
154	11	6	2026-09-10 17:06:18.117011	142	Mario Montenegro Gasparini / Renata Chequer Machado	aprovada	\N	tranca-import-6-b7842b146675503a8f8cd5bd0bd65d61e6df8fdf05e9b370362882f69d87ce85	ativo	2026-09-10 17:06:18.117011
156	11	6	2026-09-10 17:06:20.695649	144	Telma Magalhães Buckup / Anahi M. Bayma de Carvalho	aprovada	\N	tranca-import-6-19d86aaf88c8c8c0105d692861c29651e34c6aafc1d56240457f766d54610b4b	ativo	2026-09-10 17:06:20.695649
157	11	6	2026-09-10 17:06:21.986521	145	Carlos Antonio Rossi Rosa / Marcelo Fernando Lopo Lima	aprovada	\N	tranca-import-6-05c3cc03a69d59c0c9a24b627974dbea1582f663a0fa465a54ee77fcf7ef2a2d	ativo	2026-09-10 17:06:21.986521
158	11	6	2026-09-10 17:06:23.278254	146	Maria Lúcia Stape / Nilda Monteiro Calife	aprovada	\N	tranca-import-6-588428c037acc202ebe1fc374d11020da829a4a80bd7bda1ef3a9cab23f9cf0a	ativo	2026-09-10 17:06:23.278254
159	11	6	2026-09-10 17:06:24.565236	147	Marilena Simões de Queiroz / Denise F. Pignalosa	aprovada	\N	tranca-import-6-f94ec956b73e0f767d3e8e43261e39aef3b63f7d41d6158bf377f82491d700e3	ativo	2026-09-10 17:06:24.565236
146	11	6	2026-09-10 17:06:07.782529	134	Fabio Andrade Reinbold / Silvia Moll Reinbold	rejeitada	\N	tranca-import-6-17516303a91fe00dd001e26aa8b7b213b9814c248c84d56645cc53cbd290727c	ativo	2026-09-12 18:01:00.492307
155	11	6	2026-09-10 17:06:19.407824	143	Leon Majer / Marta Dubrez Pimenta Campos	rejeitada	\N	tranca-import-6-5aaaf0483b8680af2030b4239d4faee3678a169564f983b087894f37293a1a0a	ativo	2026-09-12 18:01:38.368255
\.


--
-- Data for Name: tranca_classificacao_rows; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."tranca_classificacao_rows" ("id", "category_id", "championship_id", "created_at", "draws", "goal_diff", "goals_against", "goals_for", "group_key", "losses", "played", "points", "position", "qualified", "source_id", "tranca_dupla_id", "updated_at", "wins", "stage_number") FROM stdin;
3065	11	6	2026-09-19 18:56:17.921073	0	2150	4540	6690	C	0	3	3	1	t	tranca-stage-2-standing-6-11-C-144	144	2026-09-19 18:56:17.921073	3	2
3066	11	6	2026-09-19 18:56:18.137725	0	140	5910	6050	C	2	3	1	2	t	tranca-stage-2-standing-6-11-C-123	123	2026-09-19 18:56:18.137725	1	2
2921	11	6	2026-09-14 20:33:15.758084	0	4020	5680	9700	Chave 1	0	3	3	1	\N	tranca-classification-6-11-Chave 1-156	156	2026-09-16 14:44:39.105273	3	1
2922	11	6	2026-09-14 20:33:16.05972	0	-1180	8100	6920	Chave 1	1	3	2	2	\N	tranca-classification-6-11-Chave 1-121	121	2026-09-16 14:44:39.32307	2	1
2923	11	6	2026-09-14 20:33:16.352235	0	-100	7490	7390	Chave 1	2	3	1	3	\N	tranca-classification-6-11-Chave 1-136	136	2026-09-16 14:44:39.538449	1	1
2924	11	6	2026-09-14 20:33:16.649737	0	-2740	7970	5230	Chave 1	3	3	0	4	\N	tranca-classification-6-11-Chave 1-154	154	2026-09-16 14:44:39.753281	0	1
3067	11	6	2026-09-19 18:56:18.351755	0	-670	4680	4010	C	2	3	1	3	f	tranca-stage-2-standing-6-11-C-142	142	2026-09-19 18:56:18.351755	1	2
3068	11	6	2026-09-19 18:56:18.566647	0	-1620	5840	4220	C	2	3	1	4	f	tranca-stage-2-standing-6-11-C-121	121	2026-09-19 18:56:18.566647	1	2
3069	11	6	2026-09-19 18:57:35.776652	0	710	4780	5490	B	1	3	2	1	t	tranca-stage-2-standing-6-11-B-158	158	2026-09-19 18:57:35.776652	2	2
2964	11	6	2026-09-14 20:33:30.18317	0	1910	5640	7550	Chave 10	1	3	2	2	\N	tranca-classification-6-11-Chave 10-148	148	2026-09-16 14:44:41.04676	2	1
2966	11	6	2026-09-14 20:33:30.755462	0	-1030	8730	7700	Chave 10	2	3	1	3	\N	tranca-classification-6-11-Chave 10-140	140	2026-09-16 14:44:41.264593	1	1
2967	11	6	2026-09-14 20:33:31.041653	0	-3210	7680	4470	Chave 10	3	3	0	4	\N	tranca-classification-6-11-Chave 10-124	124	2026-09-16 14:44:41.4796	0	1
3070	11	6	2026-09-19 18:57:35.990616	0	710	3900	4610	B	1	3	2	2	t	tranca-stage-2-standing-6-11-B-145	145	2026-09-19 18:57:35.990616	2	2
3071	11	6	2026-09-19 18:57:36.205276	0	-160	4920	4760	B	2	3	1	3	f	tranca-stage-2-standing-6-11-B-135	135	2026-09-19 18:57:36.205276	1	2
2957	11	6	2026-09-14 20:33:27.597809	0	1210	7060	8270	Chave 11	0	3	3	1	\N	tranca-classification-6-11-Chave 11-159	159	2026-09-16 14:44:42.617086	3	1
2960	11	6	2026-09-14 20:33:28.455034	0	-850	8160	7310	Chave 11	2	3	1	4	\N	tranca-classification-6-11-Chave 11-125	125	2026-09-16 14:44:43.272049	1	1
2928	11	6	2026-09-14 20:33:18.051976	0	2060	6010	8070	Chave 4	0	3	3	1	\N	tranca-classification-6-11-Chave 4-144	144	2026-09-16 14:44:46.838495	3	1
2927	11	6	2026-09-14 20:33:17.765388	0	2560	6110	8670	Chave 4	1	3	2	2	\N	tranca-classification-6-11-Chave 4-139	139	2026-09-16 14:44:47.052588	2	1
2938	11	6	2026-09-14 20:33:21.194721	0	-690	6820	6130	Chave 5	2	3	1	3	\N	tranca-classification-6-11-Chave 5-138	138	2026-09-16 14:44:49.027566	1	1
2939	11	6	2026-09-14 20:33:21.48292	0	-570	5990	5420	Chave 5	3	3	0	4	\N	tranca-classification-6-11-Chave 5-130	130	2026-09-16 14:44:49.242405	0	1
2943	11	6	2026-09-14 20:33:22.970934	0	1210	5440	6650	Chave 6	1	3	2	2	\N	tranca-classification-6-11-Chave 6-145	145	2026-09-16 14:44:50.528975	2	1
2980	11	6	2026-09-14 21:46:19.602252	0	2780	5250	8030	Chave 7	0	3	3	1	\N	tranca-classification-6-11-Chave 7-158	158	2026-09-16 14:44:52.17672	3	1
2979	11	6	2026-09-14 21:46:06.711056	0	4230	3440	7670	Chave 7	1	3	2	2	\N	tranca-classification-6-11-Chave 7-142	142	2026-09-16 14:44:52.392584	2	1
2978	11	6	2026-09-14 21:45:18.289072	0	-4240	7710	3470	Chave 7	2	3	1	3	\N	tranca-classification-6-11-Chave 7-149	149	2026-09-16 14:44:52.606809	1	1
2977	11	6	2026-09-14 21:44:33.215796	0	-2770	7160	4390	Chave 7	3	3	0	4	\N	tranca-classification-6-11-Chave 7-150	150	2026-09-16 14:44:52.820742	0	1
2972	11	6	2026-09-14 20:33:32.705961	0	780	6340	7120	Chave 9	0	3	3	1	\N	tranca-classification-6-11-Chave 9-123	123	2026-09-16 14:44:53.99867	3	1
2963	11	6	2026-09-14 20:33:29.894671	0	2330	4900	7230	Chave 10	0	3	3	1	\N	tranca-classification-6-11-Chave 10-152	152	2026-09-16 14:44:40.828502	3	1
3072	11	6	2026-09-19 18:57:36.418978	0	-1260	5280	4020	B	2	3	1	4	f	tranca-stage-2-standing-6-11-B-148	148	2026-09-19 18:57:36.418978	1	2
3073	11	6	2026-09-19 19:01:09.436507	0	1270	4710	5980	D	1	3	2	1	t	tranca-stage-2-standing-6-11-D-139	139	2026-09-19 19:01:09.436507	2	2
2958	11	6	2026-09-14 20:33:27.883765	0	150	7190	7340	Chave 11	2	3	1	2	\N	tranca-classification-6-11-Chave 11-143	143	2026-09-16 14:44:42.838663	1	1
3074	11	6	2026-09-19 19:01:09.652368	0	420	5040	5460	D	1	3	2	2	t	tranca-stage-2-standing-6-11-D-152	152	2026-09-19 19:01:09.652368	2	2
3075	11	6	2026-09-19 19:01:09.866765	0	-830	4900	4070	D	2	3	1	3	f	tranca-stage-2-standing-6-11-D-126	126	2026-09-19 19:01:09.866765	1	2
2959	11	6	2026-09-14 20:33:28.169496	0	-510	6800	6290	Chave 11	2	3	1	3	\N	tranca-classification-6-11-Chave 11-119	119	2026-09-16 14:44:43.057422	1	1
3076	11	6	2026-09-19 19:01:10.085197	0	-860	5150	4290	D	2	3	1	4	f	tranca-stage-2-standing-6-11-D-141	141	2026-09-19 19:01:10.085197	1	2
3077	11	6	2026-09-19 19:03:08.43371	0	600	3650	4250	A	0	3	3	1	t	tranca-stage-2-standing-6-11-A-159	159	2026-09-19 19:03:08.43371	3	2
3078	11	6	2026-09-19 19:03:08.649178	0	1640	3860	5500	A	1	3	2	2	t	tranca-stage-2-standing-6-11-A-128	128	2026-09-19 19:03:08.649178	2	2
3079	11	6	2026-09-19 19:03:08.86383	0	70	4470	4540	A	2	3	1	3	f	tranca-stage-2-standing-6-11-A-118	118	2026-09-19 19:03:08.86383	1	2
2917	11	6	2026-09-14 20:33:13.944097	0	2580	4420	7000	Chave 2	0	3	3	1	\N	tranca-classification-6-11-Chave 2-135	135	2026-09-16 14:44:44.783814	3	1
2918	11	6	2026-09-14 20:33:14.316881	0	230	6550	6780	Chave 2	2	3	1	2	\N	tranca-classification-6-11-Chave 2-131	131	2026-09-16 14:44:44.999239	1	1
2919	11	6	2026-09-14 20:33:14.603076	0	20	5950	5970	Chave 2	2	3	1	3	\N	tranca-classification-6-11-Chave 2-132	132	2026-09-16 14:44:45.215424	1	1
2920	11	6	2026-09-14 20:33:14.88976	0	-2830	7360	4530	Chave 2	2	3	1	4	\N	tranca-classification-6-11-Chave 2-122	122	2026-09-16 14:44:45.430136	1	1
3080	11	6	2026-09-19 19:03:09.07872	0	-2310	5680	3370	A	3	3	0	4	f	tranca-stage-2-standing-6-11-A-156	156	2026-09-19 19:03:09.07872	0	2
2931	11	6	2026-09-14 20:33:18.921454	0	-1600	7030	5430	Chave 4	2	3	1	3	\N	tranca-classification-6-11-Chave 4-129	129	2026-09-16 14:44:47.267743	1	1
2930	11	6	2026-09-14 20:33:18.634501	0	-3020	8580	5560	Chave 4	3	3	0	4	\N	tranca-classification-6-11-Chave 4-137	137	2026-09-16 14:44:47.489235	0	1
2936	11	6	2026-09-14 20:33:20.609744	0	150	6760	6910	Chave 5	0	3	3	1	\N	tranca-classification-6-11-Chave 5-141	141	2026-09-16 14:44:48.597142	3	1
2935	11	6	2026-09-14 20:33:20.312214	0	1110	4090	5200	Chave 5	1	3	2	2	\N	tranca-classification-6-11-Chave 5-128	128	2026-09-16 14:44:48.81373	2	1
2946	11	6	2026-09-14 20:33:23.828301	0	2350	5180	7530	Chave 6	1	3	2	1	\N	tranca-classification-6-11-Chave 6-118	118	2026-09-16 14:44:50.315284	2	1
2944	11	6	2026-09-14 20:33:23.256455	0	-170	5300	5130	Chave 6	1	3	2	3	\N	tranca-classification-6-11-Chave 6-147	147	2026-09-16 14:44:50.743896	2	1
2947	11	6	2026-09-14 20:33:24.118864	0	-3390	8070	4680	Chave 6	3	3	0	4	\N	tranca-classification-6-11-Chave 6-157	157	2026-09-16 14:44:50.961496	0	1
2974	11	6	2026-09-14 20:33:33.281417	0	1250	5860	7110	Chave 9	1	3	2	2	\N	tranca-classification-6-11-Chave 9-126	126	2026-09-16 14:44:54.212946	2	1
2970	11	6	2026-09-14 20:33:32.131693	0	0	7170	7170	Chave 9	2	3	1	3	\N	tranca-classification-6-11-Chave 9-133	133	2026-09-16 14:44:54.426893	1	1
2975	11	6	2026-09-14 20:33:33.567817	0	-2030	7850	5820	Chave 9	3	3	0	4	\N	tranca-classification-6-11-Chave 9-127	127	2026-09-16 14:44:54.641672	0	1
\.


--
-- Data for Name: tranca_dupla_memberships; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."tranca_dupla_memberships" ("id", "athlete_id", "created_at", "position", "shirt_number", "source_id", "tranca_dupla_id", "updated_at") FROM stdin;
87	96	2026-09-10 17:05:31.976287	\N	\N	team-athlete-174-96	118	2026-09-10 17:05:31.976287
88	97	2026-09-10 17:05:32.285109	\N	\N	team-athlete-174-97	118	2026-09-10 17:05:32.285109
90	99	2026-09-10 17:05:33.597865	\N	\N	team-athlete-175-99	119	2026-09-10 17:05:33.597865
91	100	2026-09-10 17:05:34.607375	\N	\N	team-athlete-176-100	120	2026-09-10 17:05:34.607375
92	101	2026-09-10 17:05:34.901625	\N	\N	team-athlete-176-101	120	2026-09-10 17:05:34.901625
93	102	2026-09-10 17:05:35.901294	\N	\N	team-athlete-177-102	121	2026-09-10 17:05:35.901294
94	103	2026-09-10 17:05:36.196077	\N	\N	team-athlete-177-103	121	2026-09-10 17:05:36.196077
95	104	2026-09-10 17:05:37.198004	\N	\N	team-athlete-178-104	122	2026-09-10 17:05:37.198004
96	105	2026-09-10 17:05:37.494657	\N	\N	team-athlete-178-105	122	2026-09-10 17:05:37.494657
97	106	2026-09-10 17:05:38.514276	\N	\N	team-athlete-179-106	123	2026-09-10 17:05:38.514276
98	107	2026-09-10 17:05:38.807991	\N	\N	team-athlete-179-107	123	2026-09-10 17:05:38.807991
99	108	2026-09-10 17:05:39.82915	\N	\N	team-athlete-180-108	124	2026-09-10 17:05:39.82915
100	109	2026-09-10 17:05:40.127071	\N	\N	team-athlete-180-109	124	2026-09-10 17:05:40.127071
101	110	2026-09-10 17:05:41.142609	\N	\N	team-athlete-181-110	125	2026-09-10 17:05:41.142609
102	111	2026-09-10 17:05:41.435764	\N	\N	team-athlete-181-111	125	2026-09-10 17:05:41.435764
103	112	2026-09-10 17:05:42.435372	\N	\N	team-athlete-182-112	126	2026-09-10 17:05:42.435372
104	113	2026-09-10 17:05:42.72873	\N	\N	team-athlete-182-113	126	2026-09-10 17:05:42.72873
105	114	2026-09-10 17:05:43.724764	\N	\N	team-athlete-183-114	127	2026-09-10 17:05:43.724764
106	115	2026-09-10 17:05:44.016823	\N	\N	team-athlete-183-115	127	2026-09-10 17:05:44.016823
107	116	2026-09-10 17:05:45.032666	\N	\N	team-athlete-184-116	128	2026-09-10 17:05:45.032666
108	117	2026-09-10 17:05:45.327274	\N	\N	team-athlete-184-117	128	2026-09-10 17:05:45.327274
109	118	2026-09-10 17:05:46.339556	\N	\N	team-athlete-185-118	129	2026-09-10 17:05:46.339556
110	119	2026-09-10 17:05:46.632865	\N	\N	team-athlete-185-119	129	2026-09-10 17:05:46.632865
111	120	2026-09-10 17:05:47.637597	\N	\N	team-athlete-186-120	130	2026-09-10 17:05:47.637597
112	121	2026-09-10 17:05:47.931625	\N	\N	team-athlete-186-121	130	2026-09-10 17:05:47.931625
113	122	2026-09-10 17:05:48.954999	\N	\N	team-athlete-187-122	131	2026-09-10 17:05:48.954999
114	123	2026-09-10 17:05:49.247662	\N	\N	team-athlete-187-123	131	2026-09-10 17:05:49.247662
115	124	2026-09-10 17:05:50.244871	\N	\N	team-athlete-188-124	132	2026-09-10 17:05:50.244871
116	125	2026-09-10 17:05:50.537737	\N	\N	team-athlete-188-125	132	2026-09-10 17:05:50.537737
117	126	2026-09-10 17:05:51.535411	\N	\N	team-athlete-189-126	133	2026-09-10 17:05:51.535411
118	127	2026-09-10 17:05:51.82788	\N	\N	team-athlete-189-127	133	2026-09-10 17:05:51.82788
119	128	2026-09-10 17:05:52.823176	\N	\N	team-athlete-190-128	134	2026-09-10 17:05:52.823176
120	129	2026-09-10 17:05:53.114853	\N	\N	team-athlete-190-129	134	2026-09-10 17:05:53.114853
121	130	2026-09-10 17:05:54.111711	\N	\N	team-athlete-191-130	135	2026-09-10 17:05:54.111711
122	131	2026-09-10 17:05:54.404273	\N	\N	team-athlete-191-131	135	2026-09-10 17:05:54.404273
123	132	2026-09-10 17:05:55.399032	\N	\N	team-athlete-192-132	136	2026-09-10 17:05:55.399032
124	133	2026-09-10 17:05:55.690893	\N	\N	team-athlete-192-133	136	2026-09-10 17:05:55.690893
125	134	2026-09-10 17:05:56.687404	\N	\N	team-athlete-193-134	137	2026-09-10 17:05:56.687404
126	135	2026-09-10 17:05:56.981689	\N	\N	team-athlete-193-135	137	2026-09-10 17:05:56.981689
127	136	2026-09-10 17:05:57.975854	\N	\N	team-athlete-194-136	138	2026-09-10 17:05:57.975854
128	137	2026-09-10 17:05:58.267979	\N	\N	team-athlete-194-137	138	2026-09-10 17:05:58.267979
129	138	2026-09-10 17:05:59.2818	\N	\N	team-athlete-195-138	139	2026-09-10 17:05:59.2818
130	139	2026-09-10 17:05:59.573915	\N	\N	team-athlete-195-139	139	2026-09-10 17:05:59.573915
131	140	2026-09-10 17:06:00.575853	\N	\N	team-athlete-196-140	140	2026-09-10 17:06:00.575853
132	141	2026-09-10 17:06:00.868509	\N	\N	team-athlete-196-141	140	2026-09-10 17:06:00.868509
133	142	2026-09-10 17:06:01.867114	\N	\N	team-athlete-197-142	141	2026-09-10 17:06:01.867114
134	143	2026-09-10 17:06:02.16054	\N	\N	team-athlete-197-143	141	2026-09-10 17:06:02.16054
135	144	2026-09-10 17:06:03.156795	\N	\N	team-athlete-198-144	142	2026-09-10 17:06:03.156795
136	145	2026-09-10 17:06:03.449057	\N	\N	team-athlete-198-145	142	2026-09-10 17:06:03.449057
137	146	2026-09-10 17:06:04.444154	\N	\N	team-athlete-199-146	143	2026-09-10 17:06:04.444154
138	147	2026-09-10 17:06:04.737158	\N	\N	team-athlete-199-147	143	2026-09-10 17:06:04.737158
139	148	2026-09-10 17:06:05.73372	\N	\N	team-athlete-200-148	144	2026-09-10 17:06:05.73372
140	149	2026-09-10 17:06:06.026523	\N	\N	team-athlete-200-149	144	2026-09-10 17:06:06.026523
141	150	2026-09-10 17:06:07.022025	\N	\N	team-athlete-201-150	145	2026-09-10 17:06:07.022025
142	151	2026-09-10 17:06:07.313981	\N	\N	team-athlete-201-151	145	2026-09-10 17:06:07.313981
143	152	2026-09-10 17:06:08.310072	\N	\N	team-athlete-202-152	146	2026-09-10 17:06:08.310072
144	153	2026-09-10 17:06:08.60324	\N	\N	team-athlete-202-153	146	2026-09-10 17:06:08.60324
145	154	2026-09-10 17:06:09.599992	\N	\N	team-athlete-203-154	147	2026-09-10 17:06:09.599992
146	155	2026-09-10 17:06:09.893228	\N	\N	team-athlete-203-155	147	2026-09-10 17:06:09.893228
147	156	2026-09-10 17:06:10.889858	\N	\N	team-athlete-204-156	148	2026-09-10 17:06:10.889858
148	157	2026-09-10 17:06:11.183106	\N	\N	team-athlete-204-157	148	2026-09-10 17:06:11.183106
149	158	2026-09-10 17:06:12.178992	\N	\N	team-athlete-205-158	149	2026-09-10 17:06:12.178992
150	159	2026-09-10 17:06:12.471126	\N	\N	team-athlete-205-159	149	2026-09-10 17:06:12.471126
151	160	2026-09-10 17:06:13.469981	\N	\N	team-athlete-206-160	150	2026-09-10 17:06:13.469981
152	161	2026-09-10 17:06:13.763237	\N	\N	team-athlete-206-161	150	2026-09-10 17:06:13.763237
153	162	2026-09-10 17:06:14.758173	\N	\N	team-athlete-207-162	151	2026-09-10 17:06:14.758173
154	163	2026-09-10 17:06:15.050677	\N	\N	team-athlete-207-163	151	2026-09-10 17:06:15.050677
155	164	2026-09-10 17:06:16.04882	\N	\N	team-athlete-208-164	152	2026-09-10 17:06:16.04882
156	165	2026-09-10 17:06:16.359763	\N	\N	team-athlete-208-165	152	2026-09-10 17:06:16.359763
157	166	2026-09-10 17:06:17.35452	\N	\N	team-athlete-209-166	153	2026-09-10 17:06:17.35452
158	167	2026-09-10 17:06:17.647448	\N	\N	team-athlete-209-167	153	2026-09-10 17:06:17.647448
159	168	2026-09-10 17:06:18.646767	\N	\N	team-athlete-210-168	154	2026-09-10 17:06:18.646767
160	169	2026-09-10 17:06:18.939538	\N	\N	team-athlete-210-169	154	2026-09-10 17:06:18.939538
161	170	2026-09-10 17:06:19.935284	\N	\N	team-athlete-211-170	155	2026-09-10 17:06:19.935284
162	171	2026-09-10 17:06:20.227938	\N	\N	team-athlete-211-171	155	2026-09-10 17:06:20.227938
163	172	2026-09-10 17:06:21.223157	\N	\N	team-athlete-212-172	156	2026-09-10 17:06:21.223157
164	173	2026-09-10 17:06:21.515615	\N	\N	team-athlete-212-173	156	2026-09-10 17:06:21.515615
165	174	2026-09-10 17:06:22.515381	\N	\N	team-athlete-213-174	157	2026-09-10 17:06:22.515381
166	175	2026-09-10 17:06:22.808542	\N	\N	team-athlete-213-175	157	2026-09-10 17:06:22.808542
167	176	2026-09-10 17:06:23.805417	\N	\N	team-athlete-214-176	158	2026-09-10 17:06:23.805417
168	177	2026-09-10 17:06:24.097305	\N	\N	team-athlete-214-177	158	2026-09-10 17:06:24.097305
169	178	2026-09-10 17:06:25.092484	\N	\N	team-athlete-215-178	159	2026-09-10 17:06:25.092484
170	179	2026-09-10 17:06:25.384567	\N	\N	team-athlete-215-179	159	2026-09-10 17:06:25.384567
171	170	2026-09-12 18:04:26.128086	\N	\N	team-athlete-742d6f42	119	2026-09-12 18:04:26.128086
\.


--
-- Data for Name: tranca_rodadas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."tranca_rodadas" ("id", "championship_id", "created_at", "ends_on", "label", "phase", "round_number", "source_id", "starts_on", "status", "updated_at", "stage_number") FROM stdin;
16	6	2026-09-10 17:09:52.082972	\N	Rodada 1 · Classificatória	classificatoria	1	tranca-round-6-classificatoria-1	\N	programada	2026-09-10 17:09:52.082972	1
17	6	2026-09-10 17:10:26.920746	\N	Rodada 2 · Classificatória	classificatoria	2	tranca-round-6-classificatoria-2	\N	programada	2026-09-10 17:10:26.920746	1
18	6	2026-09-10 17:10:57.064726	\N	Rodada 3 · Classificatória	classificatoria	3	tranca-round-6-classificatoria-3	\N	programada	2026-09-10 17:10:57.064726	1
21	6	2026-09-17 17:09:30.818703	\N	2ª etapa · Rodada 1	classificatoria	1	tranca-stage-2-round-6-1	\N	programada	2026-09-17 17:09:30.818703	2
22	6	2026-09-17 17:09:33.322841	\N	2ª etapa · Rodada 2	classificatoria	2	tranca-stage-2-round-6-2	\N	programada	2026-09-17 17:09:33.322841	2
23	6	2026-09-17 17:09:35.428719	\N	2ª etapa · Rodada 3	classificatoria	3	tranca-stage-2-round-6-3	\N	programada	2026-09-17 17:09:35.428719	2
\.


--
-- Data for Name: tranca_mesas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."tranca_mesas" ("id", "championship_id", "code", "created_at", "location", "name", "source_id", "status", "tranca_rodada_id", "updated_at") FROM stdin;
131	6	3-1	2026-09-10 17:12:44.275059	\N	Mesa 1	tranca-mesa-tranca-partida-6-11-classificatoria-3-1	disponivel	18	2026-09-10 17:12:44.275059
132	6	3-2	2026-09-10 17:12:44.738367	\N	Mesa 2	tranca-mesa-tranca-partida-6-11-classificatoria-3-2	disponivel	18	2026-09-10 17:12:44.738367
133	6	3-3	2026-09-10 17:12:45.199582	\N	Mesa 3	tranca-mesa-tranca-partida-6-11-classificatoria-3-3	disponivel	18	2026-09-10 17:12:45.199582
134	6	3-4	2026-09-10 17:12:45.657265	\N	Mesa 4	tranca-mesa-tranca-partida-6-11-classificatoria-3-4	disponivel	18	2026-09-10 17:12:45.657265
137	6	3-7	2026-09-10 17:12:47.029665	\N	Mesa 7	tranca-mesa-tranca-partida-6-11-classificatoria-3-7	disponivel	18	2026-09-10 17:12:47.029665
138	6	3-8	2026-09-10 17:12:47.488049	\N	Mesa 8	tranca-mesa-tranca-partida-6-11-classificatoria-3-8	disponivel	18	2026-09-10 17:12:47.488049
139	6	3-9	2026-09-10 17:12:47.945115	\N	Mesa 9	tranca-mesa-tranca-partida-6-11-classificatoria-3-9	disponivel	18	2026-09-10 17:12:47.945115
140	6	3-10	2026-09-10 17:12:48.403119	\N	Mesa 10	tranca-mesa-tranca-partida-6-11-classificatoria-3-10	disponivel	18	2026-09-10 17:12:48.403119
141	6	3-11	2026-09-10 17:12:48.85986	\N	Mesa 11	tranca-mesa-tranca-partida-6-11-classificatoria-3-11	disponivel	18	2026-09-10 17:12:48.85986
142	6	3-12	2026-09-10 17:12:49.316645	\N	Mesa 12	tranca-mesa-tranca-partida-6-11-classificatoria-3-12	disponivel	18	2026-09-10 17:12:49.316645
143	6	3-13	2026-09-10 17:12:49.776227	\N	Mesa 13	tranca-mesa-tranca-partida-6-11-classificatoria-3-13	disponivel	18	2026-09-10 17:12:49.776227
144	6	3-14	2026-09-10 17:12:50.232826	\N	Mesa 14	tranca-mesa-tranca-partida-6-11-classificatoria-3-14	disponivel	18	2026-09-10 17:12:50.232826
147	6	3-17	2026-09-10 17:12:51.603487	\N	Mesa 17	tranca-mesa-tranca-partida-6-11-classificatoria-3-17	disponivel	18	2026-09-10 17:12:51.603487
148	6	3-18	2026-09-10 17:12:52.0602	\N	Mesa 18	tranca-mesa-tranca-partida-6-11-classificatoria-3-18	disponivel	18	2026-09-10 17:12:52.0602
149	6	3-19	2026-09-10 17:12:52.517619	\N	Mesa 19	tranca-mesa-tranca-partida-6-11-classificatoria-3-19	disponivel	18	2026-09-10 17:12:52.517619
150	6	3-20	2026-09-10 17:12:52.994695	\N	Mesa 20	tranca-mesa-tranca-partida-6-11-classificatoria-3-20	disponivel	18	2026-09-10 17:12:52.994695
151	6	3-21	2026-09-10 17:12:53.455724	\N	Mesa 21	tranca-mesa-tranca-partida-6-11-classificatoria-3-21	disponivel	18	2026-09-10 17:12:53.455724
152	6	3-22	2026-09-10 17:12:53.914878	\N	Mesa 22	tranca-mesa-tranca-partida-6-11-classificatoria-3-22	disponivel	18	2026-09-10 17:12:53.914878
153	6	2-1	2026-09-10 17:13:26.669551	\N	Mesa 1	tranca-mesa-tranca-partida-6-11-classificatoria-2-1	disponivel	17	2026-09-10 17:13:26.669551
154	6	2-2	2026-09-10 17:13:27.127629	\N	Mesa 2	tranca-mesa-tranca-partida-6-11-classificatoria-2-2	disponivel	17	2026-09-10 17:13:27.127629
155	6	2-3	2026-09-10 17:13:27.585746	\N	Mesa 3	tranca-mesa-tranca-partida-6-11-classificatoria-2-3	disponivel	17	2026-09-10 17:13:27.585746
156	6	2-4	2026-09-10 17:13:28.044007	\N	Mesa 4	tranca-mesa-tranca-partida-6-11-classificatoria-2-4	disponivel	17	2026-09-10 17:13:28.044007
159	6	2-7	2026-09-10 17:13:29.413276	\N	Mesa 7	tranca-mesa-tranca-partida-6-11-classificatoria-2-7	disponivel	17	2026-09-10 17:13:29.413276
160	6	2-8	2026-09-10 17:13:29.869998	\N	Mesa 8	tranca-mesa-tranca-partida-6-11-classificatoria-2-8	disponivel	17	2026-09-10 17:13:29.869998
161	6	2-9	2026-09-10 17:13:30.327307	\N	Mesa 9	tranca-mesa-tranca-partida-6-11-classificatoria-2-9	disponivel	17	2026-09-10 17:13:30.327307
109	6	1-1	2026-09-10 17:12:06.295693	\N	Mesa 1	tranca-mesa-tranca-partida-6-11-classificatoria-1-1	ocupada	16	2026-09-14 13:07:01.175111
111	6	1-2	2026-09-10 17:12:07.310101	\N	Mesa 2	tranca-mesa-tranca-partida-6-11-classificatoria-1-3	ocupada	16	2026-09-14 13:07:01.569146
112	6	1-3	2026-09-10 17:12:07.766857	\N	Mesa 3	tranca-mesa-tranca-partida-6-11-classificatoria-1-4	ocupada	16	2026-09-14 13:07:01.801021
115	6	1-4	2026-09-10 17:12:09.138179	\N	Mesa 4	tranca-mesa-tranca-partida-6-11-classificatoria-1-7	ocupada	16	2026-09-14 13:07:02.0316
116	6	1-5	2026-09-10 17:12:09.59402	\N	Mesa 5	tranca-mesa-tranca-partida-6-11-classificatoria-1-8	ocupada	16	2026-09-14 13:07:02.258988
117	6	1-6	2026-09-10 17:12:10.050257	\N	Mesa 6	tranca-mesa-tranca-partida-6-11-classificatoria-1-9	ocupada	16	2026-09-14 13:07:02.489586
118	6	1-7	2026-09-10 17:12:10.508442	\N	Mesa 7	tranca-mesa-tranca-partida-6-11-classificatoria-1-10	ocupada	16	2026-09-14 13:07:02.716975
119	6	1-8	2026-09-10 17:12:10.96636	\N	Mesa 8	tranca-mesa-tranca-partida-6-11-classificatoria-1-11	ocupada	16	2026-09-14 13:07:02.943124
120	6	1-9	2026-09-10 17:12:11.424656	\N	Mesa 9	tranca-mesa-tranca-partida-6-11-classificatoria-1-12	ocupada	16	2026-09-14 13:07:03.170718
121	6	1-10	2026-09-10 17:12:11.881895	\N	Mesa 10	tranca-mesa-tranca-partida-6-11-classificatoria-1-13	ocupada	16	2026-09-14 13:07:03.399541
122	6	1-11	2026-09-10 17:12:12.338488	\N	Mesa 11	tranca-mesa-tranca-partida-6-11-classificatoria-1-14	ocupada	16	2026-09-14 13:07:03.626734
125	6	1-12	2026-09-10 17:12:13.709155	\N	Mesa 12	tranca-mesa-tranca-partida-6-11-classificatoria-1-17	ocupada	16	2026-09-14 13:07:03.855116
126	6	1-13	2026-09-10 17:12:14.166868	\N	Mesa 13	tranca-mesa-tranca-partida-6-11-classificatoria-1-18	ocupada	16	2026-09-14 13:07:04.083402
127	6	1-14	2026-09-10 17:12:14.623793	\N	Mesa 14	tranca-mesa-tranca-partida-6-11-classificatoria-1-19	ocupada	16	2026-09-14 13:07:04.320296
128	6	1-15	2026-09-10 17:12:15.080695	\N	Mesa 15	tranca-mesa-tranca-partida-6-11-classificatoria-1-20	ocupada	16	2026-09-14 13:07:04.560461
129	6	1-16	2026-09-10 17:12:15.537733	\N	Mesa 16	tranca-mesa-tranca-partida-6-11-classificatoria-1-21	ocupada	16	2026-09-14 13:07:04.789324
130	6	1-17	2026-09-10 17:12:15.995869	\N	Mesa 17	tranca-mesa-tranca-partida-6-11-classificatoria-1-22	ocupada	16	2026-09-14 13:07:05.01706
162	6	2-10	2026-09-10 17:13:30.785121	\N	Mesa 10	tranca-mesa-tranca-partida-6-11-classificatoria-2-10	disponivel	17	2026-09-10 17:13:30.785121
163	6	2-11	2026-09-10 17:13:31.247839	\N	Mesa 11	tranca-mesa-tranca-partida-6-11-classificatoria-2-11	disponivel	17	2026-09-10 17:13:31.247839
164	6	2-12	2026-09-10 17:13:31.704723	\N	Mesa 12	tranca-mesa-tranca-partida-6-11-classificatoria-2-12	disponivel	17	2026-09-10 17:13:31.704723
165	6	2-13	2026-09-10 17:13:32.162592	\N	Mesa 13	tranca-mesa-tranca-partida-6-11-classificatoria-2-13	disponivel	17	2026-09-10 17:13:32.162592
166	6	2-14	2026-09-10 17:13:32.619329	\N	Mesa 14	tranca-mesa-tranca-partida-6-11-classificatoria-2-14	disponivel	17	2026-09-10 17:13:32.619329
169	6	2-17	2026-09-10 17:13:33.990904	\N	Mesa 17	tranca-mesa-tranca-partida-6-11-classificatoria-2-17	disponivel	17	2026-09-10 17:13:33.990904
170	6	2-18	2026-09-10 17:13:34.447737	\N	Mesa 18	tranca-mesa-tranca-partida-6-11-classificatoria-2-18	disponivel	17	2026-09-10 17:13:34.447737
171	6	2-19	2026-09-10 17:13:34.905085	\N	Mesa 19	tranca-mesa-tranca-partida-6-11-classificatoria-2-19	disponivel	17	2026-09-10 17:13:34.905085
172	6	2-20	2026-09-10 17:13:35.363239	\N	Mesa 20	tranca-mesa-tranca-partida-6-11-classificatoria-2-20	disponivel	17	2026-09-10 17:13:35.363239
173	6	2-21	2026-09-10 17:13:35.819287	\N	Mesa 21	tranca-mesa-tranca-partida-6-11-classificatoria-2-21	disponivel	17	2026-09-10 17:13:35.819287
174	6	2-22	2026-09-10 17:13:36.277557	\N	Mesa 22	tranca-mesa-tranca-partida-6-11-classificatoria-2-22	disponivel	17	2026-09-10 17:13:36.277557
175	6	1-18	2026-09-14 13:07:05.374756	\N	Mesa 18	tranca-mesa-tranca-partida-manual-420be330	disponivel	16	2026-09-14 13:07:05.374756
176	6	E2-R1-M1	2026-09-17 17:09:31.034032	\N	Mesa 1	tranca-stage-2-table-6-1-1	disponivel	21	2026-09-17 17:09:31.034032
177	6	E2-R1-M2	2026-09-17 17:09:31.354479	\N	Mesa 2	tranca-stage-2-table-6-1-2	disponivel	21	2026-09-17 17:09:31.354479
178	6	E2-R1-M3	2026-09-17 17:09:31.637608	\N	Mesa 3	tranca-stage-2-table-6-1-3	disponivel	21	2026-09-17 17:09:31.637608
179	6	E2-R1-M4	2026-09-17 17:09:31.925011	\N	Mesa 4	tranca-stage-2-table-6-1-4	disponivel	21	2026-09-17 17:09:31.925011
180	6	E2-R1-M5	2026-09-17 17:09:32.220893	\N	Mesa 5	tranca-stage-2-table-6-1-5	disponivel	21	2026-09-17 17:09:32.220893
181	6	E2-R1-M6	2026-09-17 17:09:32.500539	\N	Mesa 6	tranca-stage-2-table-6-1-6	disponivel	21	2026-09-17 17:09:32.500539
182	6	E2-R1-M7	2026-09-17 17:09:32.776424	\N	Mesa 7	tranca-stage-2-table-6-1-7	disponivel	21	2026-09-17 17:09:32.776424
183	6	E2-R1-M8	2026-09-17 17:09:33.050724	\N	Mesa 8	tranca-stage-2-table-6-1-8	disponivel	21	2026-09-17 17:09:33.050724
184	6	E2-R2-M1	2026-09-17 17:09:33.433937	\N	Mesa 1	tranca-stage-2-table-6-2-1	disponivel	22	2026-09-17 17:09:33.433937
185	6	E2-R2-M2	2026-09-17 17:09:33.663468	\N	Mesa 2	tranca-stage-2-table-6-2-2	disponivel	22	2026-09-17 17:09:33.663468
186	6	E2-R2-M3	2026-09-17 17:09:33.937105	\N	Mesa 3	tranca-stage-2-table-6-2-3	disponivel	22	2026-09-17 17:09:33.937105
187	6	E2-R2-M4	2026-09-17 17:09:34.158605	\N	Mesa 4	tranca-stage-2-table-6-2-4	disponivel	22	2026-09-17 17:09:34.158605
188	6	E2-R2-M5	2026-09-17 17:09:34.432567	\N	Mesa 5	tranca-stage-2-table-6-2-5	disponivel	22	2026-09-17 17:09:34.432567
189	6	E2-R2-M6	2026-09-17 17:09:34.657341	\N	Mesa 6	tranca-stage-2-table-6-2-6	disponivel	22	2026-09-17 17:09:34.657341
190	6	E2-R2-M7	2026-09-17 17:09:34.934362	\N	Mesa 7	tranca-stage-2-table-6-2-7	disponivel	22	2026-09-17 17:09:34.934362
191	6	E2-R2-M8	2026-09-17 17:09:35.154533	\N	Mesa 8	tranca-stage-2-table-6-2-8	disponivel	22	2026-09-17 17:09:35.154533
192	6	E2-R3-M1	2026-09-17 17:09:35.536738	\N	Mesa 1	tranca-stage-2-table-6-3-1	disponivel	23	2026-09-17 17:09:35.536738
193	6	E2-R3-M2	2026-09-17 17:09:35.753409	\N	Mesa 2	tranca-stage-2-table-6-3-2	disponivel	23	2026-09-17 17:09:35.753409
194	6	E2-R3-M3	2026-09-17 17:09:36.024389	\N	Mesa 3	tranca-stage-2-table-6-3-3	disponivel	23	2026-09-17 17:09:36.024389
195	6	E2-R3-M4	2026-09-17 17:09:36.241437	\N	Mesa 4	tranca-stage-2-table-6-3-4	disponivel	23	2026-09-17 17:09:36.241437
196	6	E2-R3-M5	2026-09-17 17:09:36.514971	\N	Mesa 5	tranca-stage-2-table-6-3-5	disponivel	23	2026-09-17 17:09:36.514971
197	6	E2-R3-M6	2026-09-17 17:09:36.732786	\N	Mesa 6	tranca-stage-2-table-6-3-6	disponivel	23	2026-09-17 17:09:36.732786
198	6	E2-R3-M7	2026-09-17 17:09:37.003887	\N	Mesa 7	tranca-stage-2-table-6-3-7	disponivel	23	2026-09-17 17:09:37.003887
199	6	E2-R3-M8	2026-09-17 17:09:37.220509	\N	Mesa 8	tranca-stage-2-table-6-3-8	disponivel	23	2026-09-17 17:09:37.220509
\.


--
-- Data for Name: tranca_partidas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."tranca_partidas" ("id", "category_id", "championship_id", "code", "created_at", "decision", "dupla_a_id", "dupla_b_id", "group_key", "penalties_a", "penalties_b", "phase", "round_number", "scheduled_on", "scheduled_time", "score_a", "score_b", "source_data", "source_id", "status", "tranca_mesa_id", "tranca_rodada_id", "updated_at", "winner_id", "wo", "stage_number") FROM stdin;
199	11	6	12-TORNEIO-DE-TRANCA-CLUBE-PINHEIROS-CLASSIFICATORIA-1-3	2026-09-10 17:09:52.876491	\N	131	132	Chave 2	\N	\N	classificatoria	1	\N	\N	1930	3260	{"generated_by":"tranca_competition_flow","pairing_method":"berger_v1","round_robin_order":[136,156,139,141,145,158,127,131,124,120,125,121,122,153,130,147,142,126,134,148,144,119,146,135,155,128,118,149,123,150,140,137,143,154,161,151,138,157,160,133,132,152,129,159],"bye_ids":[]}	tranca-partida-6-11-classificatoria-1-3	finalizado	111	16	2026-09-14 18:29:35.830563	132	\N	1
263	11	6	12-TORNEIO-DE-TRANCA-CLUBE-PINHEIROS-CHAVE-1-1-18	2026-09-14 13:07:00.456489	\N	156	121	Chave 1	\N	\N	classificatoria	1	\N	\N	3360	1830	{}	tranca-partida-manual-420be330	finalizado	175	16	2026-09-14 18:26:39.688729	156	\N	1
200	11	6	12-TORNEIO-DE-TRANCA-CLUBE-PINHEIROS-CLASSIFICATORIA-1-4	2026-09-10 17:09:53.107886	\N	122	135	Chave 2	\N	\N	classificatoria	1	\N	\N	1760	2460	{"generated_by":"tranca_competition_flow","pairing_method":"berger_v1","round_robin_order":[136,156,139,141,145,158,127,131,124,120,125,121,122,153,130,147,142,126,134,148,144,119,146,135,155,128,118,149,123,150,140,137,143,154,161,151,138,157,160,133,132,152,129,159],"bye_ids":[]}	tranca-partida-6-11-classificatoria-1-4	finalizado	112	16	2026-09-14 18:21:18.246583	135	\N	1
203	11	6	12-TORNEIO-DE-TRANCA-CLUBE-PINHEIROS-CLASSIFICATORIA-1-7	2026-09-10 17:09:53.80586	\N	144	137	Chave 4	\N	\N	classificatoria	1	\N	\N	2200	1950	{"generated_by":"tranca_competition_flow","pairing_method":"berger_v1","round_robin_order":[136,156,139,141,145,158,127,131,124,120,125,121,122,153,130,147,142,126,134,148,144,119,146,135,155,128,118,149,123,150,140,137,143,154,161,151,138,157,160,133,132,152,129,159],"bye_ids":[]}	tranca-partida-6-11-classificatoria-1-7	finalizado	115	16	2026-09-14 18:33:22.281451	144	\N	1
204	11	6	12-TORNEIO-DE-TRANCA-CLUBE-PINHEIROS-CLASSIFICATORIA-1-8	2026-09-10 17:09:54.040571	\N	129	139	Chave 4	\N	\N	classificatoria	1	\N	\N	1650	2010	{"generated_by":"tranca_competition_flow","pairing_method":"berger_v1","round_robin_order":[136,156,139,141,145,158,127,131,124,120,125,121,122,153,130,147,142,126,134,148,144,119,146,135,155,128,118,149,123,150,140,137,143,154,161,151,138,157,160,133,132,152,129,159],"bye_ids":[]}	tranca-partida-6-11-classificatoria-1-8	finalizado	116	16	2026-09-14 18:36:01.772482	139	\N	1
205	11	6	12-TORNEIO-DE-TRANCA-CLUBE-PINHEIROS-CLASSIFICATORIA-1-9	2026-09-10 17:09:54.27077	\N	141	138	Chave 5	\N	\N	classificatoria	1	\N	\N	2650	2630	{"generated_by":"tranca_competition_flow","pairing_method":"berger_v1","round_robin_order":[136,156,139,141,145,158,127,131,124,120,125,121,122,153,130,147,142,126,134,148,144,119,146,135,155,128,118,149,123,150,140,137,143,154,161,151,138,157,160,133,132,152,129,159],"bye_ids":[]}	tranca-partida-6-11-classificatoria-1-9	finalizado	117	16	2026-09-14 18:38:25.057532	141	\N	1
206	11	6	12-TORNEIO-DE-TRANCA-CLUBE-PINHEIROS-CLASSIFICATORIA-1-10	2026-09-10 17:09:54.500972	\N	130	128	Chave 5	\N	\N	classificatoria	1	\N	\N	1130	1190	{"generated_by":"tranca_competition_flow","pairing_method":"berger_v1","round_robin_order":[136,156,139,141,145,158,127,131,124,120,125,121,122,153,130,147,142,126,134,148,144,119,146,135,155,128,118,149,123,150,140,137,143,154,161,151,138,157,160,133,132,152,129,159],"bye_ids":[]}	tranca-partida-6-11-classificatoria-1-10	finalizado	118	16	2026-09-14 18:41:56.540015	128	\N	1
207	11	6	12-TORNEIO-DE-TRANCA-CLUBE-PINHEIROS-CLASSIFICATORIA-1-11	2026-09-10 17:09:54.731188	\N	145	157	Chave 6	\N	\N	classificatoria	1	\N	\N	2300	1420	{"generated_by":"tranca_competition_flow","pairing_method":"berger_v1","round_robin_order":[136,156,139,141,145,158,127,131,124,120,125,121,122,153,130,147,142,126,134,148,144,119,146,135,155,128,118,149,123,150,140,137,143,154,161,151,138,157,160,133,132,152,129,159],"bye_ids":[]}	tranca-partida-6-11-classificatoria-1-11	finalizado	119	16	2026-09-14 18:47:08.770541	145	\N	1
294	11	6	E2-R1-J5	2026-09-17 17:09:32.384178	\N	144	121	C	\N	\N	classificatoria	1	\N	\N	2180	1280	{"generated_by":"tranca_second_stage_builder","kind":"second_stage_group","group_key":"C","table_number":5,"slot_a":1,"slot_b":2}	tranca-stage-2-match-6-1-5	finalizado	180	21	2026-09-19 17:32:00.463279	144	\N	2
297	11	6	E2-R1-J8	2026-09-17 17:09:33.21311	\N	139	152	D	\N	\N	classificatoria	1	\N	\N	1520	2470	{"generated_by":"tranca_second_stage_builder","kind":"second_stage_group","group_key":"D","table_number":8,"slot_a":4,"slot_b":3}	tranca-stage-2-match-6-1-8	finalizado	183	21	2026-09-19 17:35:02.184848	152	\N	2
210	11	6	12-TORNEIO-DE-TRANCA-CLUBE-PINHEIROS-CLASSIFICATORIA-1-14	2026-09-10 17:09:55.421997	\N	142	149	Chave 7	\N	\N	classificatoria	1	\N	\N	2850	-350	{"generated_by":"tranca_competition_flow","pairing_method":"berger_v1","round_robin_order":[136,156,139,141,145,158,127,131,124,120,125,121,122,153,130,147,142,126,134,148,144,119,146,135,155,128,118,149,123,150,140,137,143,154,161,151,138,157,160,133,132,152,129,159],"bye_ids":[]}	tranca-partida-6-11-classificatoria-1-14	finalizado	122	16	2026-09-14 18:52:36.312411	142	\N	1
209	11	6	12-TORNEIO-DE-TRANCA-CLUBE-PINHEIROS-CLASSIFICATORIA-1-13	2026-09-10 17:09:55.191506	\N	158	150	Chave 7	\N	\N	classificatoria	1	\N	\N	2220	1550	{"generated_by":"tranca_competition_flow","pairing_method":"berger_v1","round_robin_order":[136,156,139,141,145,158,127,131,124,120,125,121,122,153,130,147,142,126,134,148,144,119,146,135,155,128,118,149,123,150,140,137,143,154,161,151,138,157,160,133,132,152,129,159],"bye_ids":[]}	tranca-partida-6-11-classificatoria-1-13	finalizado	121	16	2026-09-14 18:50:49.237864	158	\N	1
208	11	6	12-TORNEIO-DE-TRANCA-CLUBE-PINHEIROS-CLASSIFICATORIA-1-12	2026-09-10 17:09:54.961153	\N	147	118	Chave 6	\N	\N	classificatoria	1	\N	\N	1760	1110	{"generated_by":"tranca_competition_flow","pairing_method":"berger_v1","round_robin_order":[136,156,139,141,145,158,127,131,124,120,125,121,122,153,130,147,142,126,134,148,144,119,146,135,155,128,118,149,123,150,140,137,143,154,161,151,138,157,160,133,132,152,129,159],"bye_ids":[]}	tranca-partida-6-11-classificatoria-1-12	finalizado	120	16	2026-09-14 18:49:18.263681	147	\N	1
220	11	6	12-TORNEIO-DE-TRANCA-CLUBE-PINHEIROS-CLASSIFICATORIA-2-2	2026-09-10 17:10:27.381969	\N	136	121	Chave 1	\N	\N	classificatoria	2	\N	\N	2940	2990	{"generated_by":"tranca_competition_flow","pairing_method":"berger_v1","round_robin_order":[136,156,139,141,145,158,127,131,124,120,125,121,122,153,130,147,142,126,134,148,144,119,146,135,155,128,118,149,123,150,140,137,143,154,161,151,138,157,160,133,132,152,129,159],"bye_ids":[]}	tranca-partida-6-11-classificatoria-2-2	finalizado	154	17	2026-09-14 13:56:45.672998	121	\N	1
218	11	6	12-TORNEIO-DE-TRANCA-CLUBE-PINHEIROS-CLASSIFICATORIA-1-22	2026-09-10 17:09:57.266095	\N	119	143	Chave 11	\N	\N	classificatoria	1	\N	\N	1930	2730	{"generated_by":"tranca_competition_flow","pairing_method":"berger_v1","round_robin_order":[136,156,139,141,145,158,127,131,124,120,125,121,122,153,130,147,142,126,134,148,144,119,146,135,155,128,118,149,123,150,140,137,143,154,161,151,138,157,160,133,132,152,129,159],"bye_ids":[]}	tranca-partida-6-11-classificatoria-1-22	finalizado	130	16	2026-09-14 19:03:08.343813	143	\N	1
217	11	6	12-TORNEIO-DE-TRANCA-CLUBE-PINHEIROS-CLASSIFICATORIA-1-21	2026-09-10 17:09:57.035067	\N	125	159	Chave 11	\N	\N	classificatoria	1	\N	\N	2880	3370	{"generated_by":"tranca_competition_flow","pairing_method":"berger_v1","round_robin_order":[136,156,139,141,145,158,127,131,124,120,125,121,122,153,130,147,142,126,134,148,144,119,146,135,155,128,118,149,123,150,140,137,143,154,161,151,138,157,160,133,132,152,129,159],"bye_ids":[]}	tranca-partida-6-11-classificatoria-1-21	finalizado	129	16	2026-09-14 19:04:49.182759	159	\N	1
226	11	6	12-TORNEIO-DE-TRANCA-CLUBE-PINHEIROS-CLASSIFICATORIA-2-8	2026-09-10 17:10:29.12652	\N	141	130	Chave 4	\N	\N	classificatoria	2	\N	\N	2140	2130	{"generated_by":"tranca_competition_flow","pairing_method":"berger_v1","round_robin_order":[136,156,139,141,145,158,127,131,124,120,125,121,122,153,130,147,142,126,134,148,144,119,146,135,155,128,118,149,123,150,140,137,143,154,161,151,138,157,160,133,132,152,129,159],"bye_ids":[]}	tranca-partida-6-11-classificatoria-2-8	finalizado	160	17	2026-09-14 13:57:44.6514	141	\N	1
225	11	6	12-TORNEIO-DE-TRANCA-CLUBE-PINHEIROS-CLASSIFICATORIA-2-7	2026-09-10 17:10:28.896684	\N	128	138	Chave 4	\N	\N	classificatoria	2	\N	\N	2010	840	{"generated_by":"tranca_competition_flow","pairing_method":"berger_v1","round_robin_order":[136,156,139,141,145,158,127,131,124,120,125,121,122,153,130,147,142,126,134,148,144,119,146,135,155,128,118,149,123,150,140,137,143,154,161,151,138,157,160,133,132,152,129,159],"bye_ids":[]}	tranca-partida-6-11-classificatoria-2-7	finalizado	159	17	2026-09-14 13:58:36.278426	128	\N	1
228	11	6	12-TORNEIO-DE-TRANCA-CLUBE-PINHEIROS-CLASSIFICATORIA-2-10	2026-09-10 17:10:29.586607	\N	145	147	Chave 5	\N	\N	classificatoria	2	\N	\N	3220	1440	{"generated_by":"tranca_competition_flow","pairing_method":"berger_v1","round_robin_order":[136,156,139,141,145,158,127,131,124,120,125,121,122,153,130,147,142,126,134,148,144,119,146,135,155,128,118,149,123,150,140,137,143,154,161,151,138,157,160,133,132,152,129,159],"bye_ids":[]}	tranca-partida-6-11-classificatoria-2-10	finalizado	162	17	2026-09-14 14:00:08.233598	145	\N	1
227	11	6	12-TORNEIO-DE-TRANCA-CLUBE-PINHEIROS-CLASSIFICATORIA-2-9	2026-09-10 17:10:29.357065	\N	118	157	Chave 5	\N	\N	classificatoria	2	\N	\N	3840	2290	{"generated_by":"tranca_competition_flow","pairing_method":"berger_v1","round_robin_order":[136,156,139,141,145,158,127,131,124,120,125,121,122,153,130,147,142,126,134,148,144,119,146,135,155,128,118,149,123,150,140,137,143,154,161,151,138,157,160,133,132,152,129,159],"bye_ids":[]}	tranca-partida-6-11-classificatoria-2-9	finalizado	161	17	2026-09-14 14:00:47.445008	118	\N	1
302	11	6	E2-R2-J5	2026-09-17 17:09:34.541276	\N	142	144	C	\N	\N	classificatoria	2	\N	\N	830	2030	{"generated_by":"tranca_second_stage_builder","kind":"second_stage_group","group_key":"C","table_number":5,"slot_a":4,"slot_b":1}	tranca-stage-2-match-6-2-5	finalizado	188	22	2026-09-19 18:09:26.199291	144	\N	2
219	11	6	12-TORNEIO-DE-TRANCA-CLUBE-PINHEIROS-CLASSIFICATORIA-2-1	2026-09-10 17:10:27.151705	\N	156	154	Chave 1	\N	\N	classificatoria	2	\N	\N	3530	1740	{"generated_by":"tranca_competition_flow","pairing_method":"berger_v1","round_robin_order":[136,156,139,141,145,158,127,131,124,120,125,121,122,153,130,147,142,126,134,148,144,119,146,135,155,128,118,149,123,150,140,137,143,154,161,151,138,157,160,133,132,152,129,159],"bye_ids":[]}	tranca-partida-6-11-classificatoria-2-1	finalizado	153	17	2026-09-14 15:13:27.59498	156	\N	1
221	11	6	12-TORNEIO-DE-TRANCA-CLUBE-PINHEIROS-CLASSIFICATORIA-2-3	2026-09-10 17:10:27.611991	\N	135	132	Chave 2	\N	\N	classificatoria	2	\N	\N	1480	730	{"generated_by":"tranca_competition_flow","pairing_method":"berger_v1","round_robin_order":[136,156,139,141,145,158,127,131,124,120,125,121,122,153,130,147,142,126,134,148,144,119,146,135,155,128,118,149,123,150,140,137,143,154,161,151,138,157,160,133,132,152,129,159],"bye_ids":[]}	tranca-partida-6-11-classificatoria-2-3	finalizado	155	17	2026-09-14 15:43:28.551326	135	\N	1
216	11	6	12-TORNEIO-DE-TRANCA-CLUBE-PINHEIROS-CLASSIFICATORIA-1-20	2026-09-10 17:09:56.803956	\N	124	152	Chave 10	\N	\N	classificatoria	1	\N	\N	640	2450	{"generated_by":"tranca_competition_flow","pairing_method":"berger_v1","round_robin_order":[136,156,139,141,145,158,127,131,124,120,125,121,122,153,130,147,142,126,134,148,144,119,146,135,155,128,118,149,123,150,140,137,143,154,161,151,138,157,160,133,132,152,129,159],"bye_ids":[]}	tranca-partida-6-11-classificatoria-1-20	finalizado	128	16	2026-09-14 19:01:37.571033	152	\N	1
222	11	6	12-TORNEIO-DE-TRANCA-CLUBE-PINHEIROS-CLASSIFICATORIA-2-4	2026-09-10 17:10:27.842636	\N	131	122	Chave 2	\N	\N	classificatoria	2	\N	\N	2920	230	{"generated_by":"tranca_competition_flow","pairing_method":"berger_v1","round_robin_order":[136,156,139,141,145,158,127,131,124,120,125,121,122,153,130,147,142,126,134,148,144,119,146,135,155,128,118,149,123,150,140,137,143,154,161,151,138,157,160,133,132,152,129,159],"bye_ids":[]}	tranca-partida-6-11-classificatoria-2-4	finalizado	156	17	2026-09-14 15:46:49.238541	131	\N	1
215	11	6	12-TORNEIO-DE-TRANCA-CLUBE-PINHEIROS-CLASSIFICATORIA-1-19	2026-09-10 17:09:56.573532	\N	148	140	Chave 10	\N	\N	classificatoria	1	\N	\N	3400	2360	{"generated_by":"tranca_competition_flow","pairing_method":"berger_v1","round_robin_order":[136,156,139,141,145,158,127,131,124,120,125,121,122,153,130,147,142,126,134,148,144,119,146,135,155,128,118,149,123,150,140,137,143,154,161,151,138,157,160,133,132,152,129,159],"bye_ids":[]}	tranca-partida-6-11-classificatoria-1-19	finalizado	127	16	2026-09-14 18:59:29.659533	148	\N	1
238	11	6	12-TORNEIO-DE-TRANCA-CLUBE-PINHEIROS-CLASSIFICATORIA-2-20	2026-09-10 17:10:31.907608	\N	144	139	Chave 10	\N	\N	classificatoria	2	\N	\N	2810	2660	{"generated_by":"tranca_competition_flow","pairing_method":"berger_v1","round_robin_order":[136,156,139,141,145,158,127,131,124,120,125,121,122,153,130,147,142,126,134,148,144,119,146,135,155,128,118,149,123,150,140,137,143,154,161,151,138,157,160,133,132,152,129,159],"bye_ids":[]}	tranca-partida-6-11-classificatoria-2-20	finalizado	172	17	2026-09-14 19:11:39.559966	144	\N	1
230	11	6	12-TORNEIO-DE-TRANCA-CLUBE-PINHEIROS-CLASSIFICATORIA-2-12	2026-09-10 17:10:30.04807	\N	158	142	Chave 6	\N	\N	classificatoria	2	\N	\N	2680	2210	{"generated_by":"tranca_competition_flow","pairing_method":"berger_v1","round_robin_order":[136,156,139,141,145,158,127,131,124,120,125,121,122,153,130,147,142,126,134,148,144,119,146,135,155,128,118,149,123,150,140,137,143,154,161,151,138,157,160,133,132,152,129,159],"bye_ids":[]}	tranca-partida-6-11-classificatoria-2-12	finalizado	164	17	2026-09-14 14:01:45.295238	158	\N	1
232	11	6	12-TORNEIO-DE-TRANCA-CLUBE-PINHEIROS-CLASSIFICATORIA-2-14	2026-09-10 17:10:30.509357	\N	127	126	Chave 7	\N	\N	classificatoria	2	\N	\N	1700	2210	{"generated_by":"tranca_competition_flow","pairing_method":"berger_v1","round_robin_order":[136,156,139,141,145,158,127,131,124,120,125,121,122,153,130,147,142,126,134,148,144,119,146,135,155,128,118,149,123,150,140,137,143,154,161,151,138,157,160,133,132,152,129,159],"bye_ids":[]}	tranca-partida-6-11-classificatoria-2-14	finalizado	166	17	2026-09-14 14:04:23.205605	126	\N	1
231	11	6	12-TORNEIO-DE-TRANCA-CLUBE-PINHEIROS-CLASSIFICATORIA-2-13	2026-09-10 17:10:30.278838	\N	123	133	Chave 7	\N	\N	classificatoria	2	\N	\N	2380	2110	{"generated_by":"tranca_competition_flow","pairing_method":"berger_v1","round_robin_order":[136,156,139,141,145,158,127,131,124,120,125,121,122,153,130,147,142,126,134,148,144,119,146,135,155,128,118,149,123,150,140,137,143,154,161,151,138,157,160,133,132,152,129,159],"bye_ids":[]}	tranca-partida-6-11-classificatoria-2-13	finalizado	165	17	2026-09-14 14:05:16.876865	123	\N	1
236	11	6	12-TORNEIO-DE-TRANCA-CLUBE-PINHEIROS-CLASSIFICATORIA-2-18	2026-09-10 17:10:31.432565	\N	124	148	Chave 9	\N	\N	classificatoria	2	\N	\N	1480	2580	{"generated_by":"tranca_competition_flow","pairing_method":"berger_v1","round_robin_order":[136,156,139,141,145,158,127,131,124,120,125,121,122,153,130,147,142,126,134,148,144,119,146,135,155,128,118,149,123,150,140,137,143,154,161,151,138,157,160,133,132,152,129,159],"bye_ids":[]}	tranca-partida-6-11-classificatoria-2-18	finalizado	170	17	2026-09-14 14:27:15.439696	148	\N	1
235	11	6	12-TORNEIO-DE-TRANCA-CLUBE-PINHEIROS-CLASSIFICATORIA-2-17	2026-09-10 17:10:31.200587	\N	140	152	Chave 9	\N	\N	classificatoria	2	\N	\N	2690	2980	{"generated_by":"tranca_competition_flow","pairing_method":"berger_v1","round_robin_order":[136,156,139,141,145,158,127,131,124,120,125,121,122,153,130,147,142,126,134,148,144,119,146,135,155,128,118,149,123,150,140,137,143,154,161,151,138,157,160,133,132,152,129,159],"bye_ids":[]}	tranca-partida-6-11-classificatoria-2-17	finalizado	169	17	2026-09-14 14:27:54.613605	152	\N	1
240	11	6	12-TORNEIO-DE-TRANCA-CLUBE-PINHEIROS-CLASSIFICATORIA-2-22	2026-09-10 17:10:32.371504	\N	125	119	Chave 11	\N	\N	classificatoria	2	\N	\N	1820	2660	{"generated_by":"tranca_competition_flow","pairing_method":"berger_v1","round_robin_order":[136,156,139,141,145,158,127,131,124,120,125,121,122,153,130,147,142,126,134,148,144,119,146,135,155,128,118,149,123,150,140,137,143,154,161,151,138,157,160,133,132,152,129,159],"bye_ids":[]}	tranca-partida-6-11-classificatoria-2-22	finalizado	174	17	2026-09-14 14:29:04.02391	119	\N	1
239	11	6	12-TORNEIO-DE-TRANCA-CLUBE-PINHEIROS-CLASSIFICATORIA-2-21	2026-09-10 17:10:32.139334	\N	143	159	Chave 11	\N	\N	classificatoria	2	\N	\N	2480	2650	{"generated_by":"tranca_competition_flow","pairing_method":"berger_v1","round_robin_order":[136,156,139,141,145,158,127,131,124,120,125,121,122,153,130,147,142,126,134,148,144,119,146,135,155,128,118,149,123,150,140,137,143,154,161,151,138,157,160,133,132,152,129,159],"bye_ids":[]}	tranca-partida-6-11-classificatoria-2-21	finalizado	173	17	2026-09-14 14:29:30.652797	159	\N	1
229	11	6	12-TORNEIO-DE-TRANCA-CLUBE-PINHEIROS-CLASSIFICATORIA-2-11	2026-09-10 17:10:29.817098	\N	149	150	Chave 6	\N	\N	classificatoria	2	\N	\N	2330	1730	{"generated_by":"tranca_competition_flow","pairing_method":"berger_v1","round_robin_order":[136,156,139,141,145,158,127,131,124,120,125,121,122,153,130,147,142,126,134,148,144,119,146,135,155,128,118,149,123,150,140,137,143,154,161,151,138,157,160,133,132,152,129,159],"bye_ids":[]}	tranca-partida-6-11-classificatoria-2-11	finalizado	163	17	2026-09-14 14:44:59.869783	149	\N	1
237	11	6	12-TORNEIO-DE-TRANCA-CLUBE-PINHEIROS-CLASSIFICATORIA-2-19	2026-09-10 17:10:31.662342	\N	139	137	Chave 10	\N	\N	classificatoria	2	\N	\N	4000	1650	{"generated_by":"tranca_competition_flow","pairing_method":"berger_v1","round_robin_order":[136,156,139,141,145,158,127,131,124,120,125,121,122,153,130,147,142,126,134,148,144,119,146,135,155,128,118,149,123,150,140,137,143,154,161,151,138,157,160,133,132,152,129,159],"bye_ids":[]}	tranca-partida-6-11-classificatoria-2-19	finalizado	171	17	2026-09-14 14:47:51.146342	139	\N	1
243	11	6	12-TORNEIO-DE-TRANCA-CLUBE-PINHEIROS-CLASSIFICATORIA-3-3	2026-09-10 17:10:57.755633	\N	122	132	Chave 2	\N	\N	classificatoria	3	\N	\N	2540	1980	{"generated_by":"tranca_competition_flow","pairing_method":"berger_v1","round_robin_order":[136,156,139,141,145,158,127,131,124,120,125,121,122,153,130,147,142,126,134,148,144,119,146,135,155,128,118,149,123,150,140,137,143,154,161,151,138,157,160,133,132,152,129,159],"bye_ids":[]}	tranca-partida-6-11-classificatoria-3-3	finalizado	133	18	2026-09-14 19:28:17.692201	122	\N	1
290	11	6	E2-R1-J1	2026-09-17 17:09:31.222867	\N	156	159	A	\N	\N	classificatoria	1	\N	\N	1530	1690	{"generated_by":"tranca_second_stage_builder","kind":"second_stage_group","group_key":"A","table_number":1,"slot_a":1,"slot_b":2}	tranca-stage-2-match-6-1-1	finalizado	176	21	2026-09-19 17:39:01.597873	159	\N	2
292	11	6	E2-R1-J3	2026-09-17 17:09:31.803552	\N	135	145	B	\N	\N	classificatoria	1	\N	\N	1980	620	{"generated_by":"tranca_second_stage_builder","kind":"second_stage_group","group_key":"B","table_number":3,"slot_a":1,"slot_b":2}	tranca-stage-2-match-6-1-3	finalizado	178	21	2026-09-19 17:40:28.999791	135	\N	2
291	11	6	E2-R1-J2	2026-09-17 17:09:31.518388	\N	128	118	A	\N	\N	classificatoria	1	\N	\N	2220	1710	{"generated_by":"tranca_second_stage_builder","kind":"second_stage_group","group_key":"A","table_number":2,"slot_a":4,"slot_b":3}	tranca-stage-2-match-6-1-2	finalizado	177	21	2026-09-19 17:41:31.537799	128	\N	2
293	11	6	E2-R1-J4	2026-09-17 17:09:32.107341	\N	148	158	B	\N	\N	classificatoria	1	\N	\N	1280	2010	{"generated_by":"tranca_second_stage_builder","kind":"second_stage_group","group_key":"B","table_number":4,"slot_a":4,"slot_b":3}	tranca-stage-2-match-6-1-4	finalizado	179	21	2026-09-19 17:42:16.166439	158	\N	2
244	11	6	12-TORNEIO-DE-TRANCA-CLUBE-PINHEIROS-CLASSIFICATORIA-3-4	2026-09-10 17:10:57.985318	\N	135	131	Chave 2	\N	\N	classificatoria	3	\N	\N	3060	1930	{"generated_by":"tranca_competition_flow","pairing_method":"berger_v1","round_robin_order":[136,156,139,141,145,158,127,131,124,120,125,121,122,153,130,147,142,126,134,148,144,119,146,135,155,128,118,149,123,150,140,137,143,154,161,151,138,157,160,133,132,152,129,159],"bye_ids":[]}	tranca-partida-6-11-classificatoria-3-4	finalizado	134	18	2026-09-14 14:59:16.33793	135	\N	1
258	11	6	12-TORNEIO-DE-TRANCA-CLUBE-PINHEIROS-CLASSIFICATORIA-3-18	2026-09-10 17:11:01.226764	\N	140	124	Chave 9	\N	\N	classificatoria	3	\N	\N	2650	2350	{"generated_by":"tranca_competition_flow","pairing_method":"berger_v1","round_robin_order":[136,156,139,141,145,158,127,131,124,120,125,121,122,153,130,147,142,126,134,148,144,119,146,135,155,128,118,149,123,150,140,137,143,154,161,151,138,157,160,133,132,152,129,159],"bye_ids":[]}	tranca-partida-6-11-classificatoria-3-18	finalizado	148	18	2026-09-12 21:08:31.894855	140	\N	1
257	11	6	12-TORNEIO-DE-TRANCA-CLUBE-PINHEIROS-CLASSIFICATORIA-3-17	2026-09-10 17:11:00.996697	\N	148	152	Chave 9	\N	\N	classificatoria	3	\N	\N	1570	1800	{"generated_by":"tranca_competition_flow","pairing_method":"berger_v1","round_robin_order":[136,156,139,141,145,158,127,131,124,120,125,121,122,153,130,147,142,126,134,148,144,119,146,135,155,128,118,149,123,150,140,137,143,154,161,151,138,157,160,133,132,152,129,159],"bye_ids":[]}	tranca-partida-6-11-classificatoria-3-17	finalizado	147	18	2026-09-12 21:09:32.702548	152	\N	1
250	11	6	12-TORNEIO-DE-TRANCA-CLUBE-PINHEIROS-CLASSIFICATORIA-3-10	2026-09-10 17:10:59.370589	\N	118	145	Chave 5	\N	\N	classificatoria	3	\N	\N	2580	1130	{"generated_by":"tranca_competition_flow","pairing_method":"berger_v1","round_robin_order":[136,156,139,141,145,158,127,131,124,120,125,121,122,153,130,147,142,126,134,148,144,119,146,135,155,128,118,149,123,150,140,137,143,154,161,151,138,157,160,133,132,152,129,159],"bye_ids":[]}	tranca-partida-6-11-classificatoria-3-10	finalizado	140	18	2026-09-12 21:10:24.399658	118	\N	1
249	11	6	12-TORNEIO-DE-TRANCA-CLUBE-PINHEIROS-CLASSIFICATORIA-3-9	2026-09-10 17:10:59.139533	\N	147	157	Chave 5	\N	\N	classificatoria	3	\N	\N	1930	970	{"generated_by":"tranca_competition_flow","pairing_method":"berger_v1","round_robin_order":[136,156,139,141,145,158,127,131,124,120,125,121,122,153,130,147,142,126,134,148,144,119,146,135,155,128,118,149,123,150,140,137,143,154,161,151,138,157,160,133,132,152,129,159],"bye_ids":[]}	tranca-partida-6-11-classificatoria-3-9	finalizado	139	18	2026-09-12 21:11:23.314865	147	\N	1
247	11	6	12-TORNEIO-DE-TRANCA-CLUBE-PINHEIROS-CLASSIFICATORIA-3-7	2026-09-10 17:10:58.679724	\N	130	138	Chave 4	\N	\N	classificatoria	3	\N	\N	2160	2660	{"generated_by":"tranca_competition_flow","pairing_method":"berger_v1","round_robin_order":[136,156,139,141,145,158,127,131,124,120,125,121,122,153,130,147,142,126,134,148,144,119,146,135,155,128,118,149,123,150,140,137,143,154,161,151,138,157,160,133,132,152,129,159],"bye_ids":[]}	tranca-partida-6-11-classificatoria-3-7	finalizado	137	18	2026-09-12 21:13:15.158581	138	\N	1
254	11	6	12-TORNEIO-DE-TRANCA-CLUBE-PINHEIROS-CLASSIFICATORIA-3-14	2026-09-10 17:11:00.295227	\N	123	127	Chave 7	\N	\N	classificatoria	3	\N	\N	2350	2050	{"generated_by":"tranca_competition_flow","pairing_method":"berger_v1","round_robin_order":[136,156,139,141,145,158,127,131,124,120,125,121,122,153,130,147,142,126,134,148,144,119,146,135,155,128,118,149,123,150,140,137,143,154,161,151,138,157,160,133,132,152,129,159],"bye_ids":[]}	tranca-partida-6-11-classificatoria-3-14	finalizado	144	18	2026-09-12 21:15:37.564869	123	\N	1
252	11	6	12-TORNEIO-DE-TRANCA-CLUBE-PINHEIROS-CLASSIFICATORIA-3-12	2026-09-10 17:10:59.832079	\N	149	158	Chave 6	\N	\N	classificatoria	3	\N	\N	1490	3130	{"generated_by":"tranca_competition_flow","pairing_method":"berger_v1","round_robin_order":[136,156,139,141,145,158,127,131,124,120,125,121,122,153,130,147,142,126,134,148,144,119,146,135,155,128,118,149,123,150,140,137,143,154,161,151,138,157,160,133,132,152,129,159],"bye_ids":[]}	tranca-partida-6-11-classificatoria-3-12	finalizado	142	18	2026-09-12 21:18:16.284361	158	\N	1
259	11	6	12-TORNEIO-DE-TRANCA-CLUBE-PINHEIROS-CLASSIFICATORIA-3-19	2026-09-10 17:11:01.45692	\N	144	129	Chave 10	\N	\N	classificatoria	3	\N	\N	3060	1400	{"generated_by":"tranca_competition_flow","pairing_method":"berger_v1","round_robin_order":[136,156,139,141,145,158,127,131,124,120,125,121,122,153,130,147,142,126,134,148,144,119,146,135,155,128,118,149,123,150,140,137,143,154,161,151,138,157,160,133,132,152,129,159],"bye_ids":[]}	tranca-partida-6-11-classificatoria-3-19	finalizado	149	18	2026-09-14 14:28:26.735774	144	\N	1
260	11	6	12-TORNEIO-DE-TRANCA-CLUBE-PINHEIROS-CLASSIFICATORIA-3-20	2026-09-10 17:11:01.686848	\N	137	129	Chave 10	\N	\N	classificatoria	3	\N	\N	1960	2380	{"generated_by":"tranca_competition_flow","pairing_method":"berger_v1","round_robin_order":[136,156,139,141,145,158,127,131,124,120,125,121,122,153,130,147,142,126,134,148,144,119,146,135,155,128,118,149,123,150,140,137,143,154,161,151,138,157,160,133,132,152,129,159],"bye_ids":[]}	tranca-partida-6-11-classificatoria-3-20	finalizado	150	18	2026-09-14 14:56:12.03307	129	\N	1
253	11	6	12-TORNEIO-DE-TRANCA-CLUBE-PINHEIROS-CLASSIFICATORIA-3-13	2026-09-10 17:11:00.062587	\N	126	133	Chave 7	\N	\N	classificatoria	3	\N	\N	2720	1770	{"generated_by":"tranca_competition_flow","pairing_method":"berger_v1","round_robin_order":[136,156,139,141,145,158,127,131,124,120,125,121,122,153,130,147,142,126,134,148,144,119,146,135,155,128,118,149,123,150,140,137,143,154,161,151,138,157,160,133,132,152,129,159],"bye_ids":[]}	tranca-partida-6-11-classificatoria-3-13	finalizado	143	18	2026-09-14 14:53:44.383734	126	\N	1
251	11	6	12-TORNEIO-DE-TRANCA-CLUBE-PINHEIROS-CLASSIFICATORIA-3-11	2026-09-10 17:10:59.60194	\N	142	150	Chave 6	\N	\N	classificatoria	3	\N	\N	2610	1110	{"generated_by":"tranca_competition_flow","pairing_method":"berger_v1","round_robin_order":[136,156,139,141,145,158,127,131,124,120,125,121,122,153,130,147,142,126,134,148,144,119,146,135,155,128,118,149,123,150,140,137,143,154,161,151,138,157,160,133,132,152,129,159],"bye_ids":[]}	tranca-partida-6-11-classificatoria-3-11	finalizado	141	18	2026-09-14 15:10:04.630179	142	\N	1
295	11	6	E2-R1-J6	2026-09-17 17:09:32.666775	\N	142	123	C	\N	\N	classificatoria	1	\N	\N	1160	1980	{"generated_by":"tranca_second_stage_builder","kind":"second_stage_group","group_key":"C","table_number":6,"slot_a":4,"slot_b":3}	tranca-stage-2-match-6-1-6	finalizado	181	21	2026-09-19 17:38:08.154386	123	\N	2
296	11	6	E2-R1-J7	2026-09-17 17:09:32.94164	\N	141	126	D	\N	\N	classificatoria	1	\N	\N	1340	1260	{"generated_by":"tranca_second_stage_builder","kind":"second_stage_group","group_key":"D","table_number":7,"slot_a":1,"slot_b":2}	tranca-stage-2-match-6-1-7	finalizado	182	21	2026-09-19 17:43:31.256381	141	\N	2
301	11	6	E2-R2-J4	2026-09-17 17:09:34.322833	\N	158	145	B	\N	\N	classificatoria	2	\N	\N	1050	2070	{"generated_by":"tranca_second_stage_builder","kind":"second_stage_group","group_key":"B","table_number":4,"slot_a":3,"slot_b":2}	tranca-stage-2-match-6-2-4	finalizado	187	22	2026-09-19 18:14:36.091429	145	\N	2
300	11	6	E2-R2-J3	2026-09-17 17:09:34.048546	\N	148	135	B	\N	\N	classificatoria	2	\N	\N	1870	1350	{"generated_by":"tranca_second_stage_builder","kind":"second_stage_group","group_key":"B","table_number":3,"slot_a":4,"slot_b":1}	tranca-stage-2-match-6-2-3	finalizado	186	22	2026-09-19 18:18:53.435013	148	\N	2
299	11	6	E2-R2-J2	2026-09-17 17:09:33.827871	\N	118	159	A	\N	\N	classificatoria	2	\N	\N	630	990	{"generated_by":"tranca_second_stage_builder","kind":"second_stage_group","group_key":"A","table_number":2,"slot_a":3,"slot_b":2}	tranca-stage-2-match-6-2-2	finalizado	185	22	2026-09-19 18:20:17.541675	159	\N	2
298	11	6	E2-R2-J1	2026-09-17 17:09:33.550097	\N	128	156	A	\N	\N	classificatoria	2	\N	\N	1790	580	{"generated_by":"tranca_second_stage_builder","kind":"second_stage_group","group_key":"A","table_number":1,"slot_a":4,"slot_b":1}	tranca-stage-2-match-6-2-1	finalizado	184	22	2026-09-19 18:21:17.801833	128	\N	2
197	11	6	12-TORNEIO-DE-TRANCA-CLUBE-PINHEIROS-CLASSIFICATORIA-1-1	2026-09-10 17:09:52.393502	\N	136	154	Chave 1	\N	\N	classificatoria	1	\N	\N	2340	1690	{"generated_by":"tranca_competition_flow","pairing_method":"berger_v1","round_robin_order":[136,156,139,141,145,158,127,131,124,120,125,121,122,153,130,147,142,126,134,148,144,119,146,135,155,128,118,149,123,150,140,137,143,154,161,151,138,157,160,133,132,152,129,159],"bye_ids":[]}	tranca-partida-6-11-classificatoria-1-1	finalizado	109	16	2026-09-14 17:43:30.429202	136	\N	1
214	11	6	12-TORNEIO-DE-TRANCA-CLUBE-PINHEIROS-CLASSIFICATORIA-1-18	2026-09-10 17:09:56.343824	\N	127	133	Chave 9	\N	\N	classificatoria	1	\N	\N	2070	3290	{"generated_by":"tranca_competition_flow","pairing_method":"berger_v1","round_robin_order":[136,156,139,141,145,158,127,131,124,120,125,121,122,153,130,147,142,126,134,148,144,119,146,135,155,128,118,149,123,150,140,137,143,154,161,151,138,157,160,133,132,152,129,159],"bye_ids":[]}	tranca-partida-6-11-classificatoria-1-18	finalizado	126	16	2026-09-14 18:57:44.364176	133	\N	1
213	11	6	12-TORNEIO-DE-TRANCA-CLUBE-PINHEIROS-CLASSIFICATORIA-1-17	2026-09-10 17:09:56.112557	\N	126	123	Chave 9	\N	\N	classificatoria	1	\N	\N	2180	2390	{"generated_by":"tranca_competition_flow","pairing_method":"berger_v1","round_robin_order":[136,156,139,141,145,158,127,131,124,120,125,121,122,153,130,147,142,126,134,148,144,119,146,135,155,128,118,149,123,150,140,137,143,154,161,151,138,157,160,133,132,152,129,159],"bye_ids":[]}	tranca-partida-6-11-classificatoria-1-17	finalizado	125	16	2026-09-14 18:54:30.174421	123	\N	1
262	11	6	12-TORNEIO-DE-TRANCA-CLUBE-PINHEIROS-CLASSIFICATORIA-3-22	2026-09-10 17:11:02.149101	\N	143	125	Chave 11	\N	\N	classificatoria	3	\N	\N	2130	2610	{"generated_by":"tranca_competition_flow","pairing_method":"berger_v1","round_robin_order":[136,156,139,141,145,158,127,131,124,120,125,121,122,153,130,147,142,126,134,148,144,119,146,135,155,128,118,149,123,150,140,137,143,154,161,151,138,157,160,133,132,152,129,159],"bye_ids":[]}	tranca-partida-6-11-classificatoria-3-22	finalizado	152	18	2026-09-12 21:12:28.402216	125	\N	1
261	11	6	12-TORNEIO-DE-TRANCA-CLUBE-PINHEIROS-CLASSIFICATORIA-3-21	2026-09-10 17:11:01.916608	\N	119	159	Chave 11	\N	\N	classificatoria	3	\N	\N	1700	2250	{"generated_by":"tranca_competition_flow","pairing_method":"berger_v1","round_robin_order":[136,156,139,141,145,158,127,131,124,120,125,121,122,153,130,147,142,126,134,148,144,119,146,135,155,128,118,149,123,150,140,137,143,154,161,151,138,157,160,133,132,152,129,159],"bye_ids":[]}	tranca-partida-6-11-classificatoria-3-21	finalizado	151	18	2026-09-12 21:14:38.172155	159	\N	1
248	11	6	12-TORNEIO-DE-TRANCA-CLUBE-PINHEIROS-CLASSIFICATORIA-3-8	2026-09-10 17:10:58.909396	\N	128	141	Chave 4	\N	\N	classificatoria	3	\N	\N	2000	2120	{"generated_by":"tranca_competition_flow","pairing_method":"berger_v1","round_robin_order":[136,156,139,141,145,158,127,131,124,120,125,121,122,153,130,147,142,126,134,148,144,119,146,135,155,128,118,149,123,150,140,137,143,154,161,151,138,157,160,133,132,152,129,159],"bye_ids":[]}	tranca-partida-6-11-classificatoria-3-8	finalizado	138	18	2026-09-12 21:17:15.083961	141	\N	1
303	11	6	E2-R2-J6	2026-09-17 17:09:34.825195	\N	123	121	C	\N	\N	classificatoria	2	\N	\N	1640	2270	{"generated_by":"tranca_second_stage_builder","kind":"second_stage_group","group_key":"C","table_number":6,"slot_a":3,"slot_b":2}	tranca-stage-2-match-6-2-6	finalizado	189	22	2026-09-19 18:12:39.660242	121	\N	2
305	11	6	E2-R2-J8	2026-09-17 17:09:35.316023	\N	152	126	D	\N	\N	classificatoria	2	\N	\N	1390	2190	{"generated_by":"tranca_second_stage_builder","kind":"second_stage_group","group_key":"D","table_number":8,"slot_a":3,"slot_b":2}	tranca-stage-2-match-6-2-8	finalizado	191	22	2026-09-19 18:16:25.484759	126	\N	2
241	11	6	12-TORNEIO-DE-TRANCA-CLUBE-PINHEIROS-CLASSIFICATORIA-3-1	2026-09-10 17:10:57.29492	\N	121	154	Chave 1	\N	\N	classificatoria	3	\N	\N	2100	1800	{"generated_by":"tranca_competition_flow","pairing_method":"berger_v1","round_robin_order":[136,156,139,141,145,158,127,131,124,120,125,121,122,153,130,147,142,126,134,148,144,119,146,135,155,128,118,149,123,150,140,137,143,154,161,151,138,157,160,133,132,152,129,159],"bye_ids":[]}	tranca-partida-6-11-classificatoria-3-1	finalizado	131	18	2026-09-14 19:19:52.300154	121	\N	1
304	11	6	E2-R2-J7	2026-09-17 17:09:35.046225	\N	139	141	D	\N	\N	classificatoria	2	\N	\N	2290	1620	{"generated_by":"tranca_second_stage_builder","kind":"second_stage_group","group_key":"D","table_number":7,"slot_a":4,"slot_b":1}	tranca-stage-2-match-6-2-7	finalizado	190	22	2026-09-19 18:22:02.229042	139	\N	2
242	11	6	12-TORNEIO-DE-TRANCA-CLUBE-PINHEIROS-CLASSIFICATORIA-3-2	2026-09-10 17:10:57.525383	\N	156	136	Chave 1	\N	\N	classificatoria	3	\N	\N	2810	2110	{"generated_by":"tranca_competition_flow","pairing_method":"berger_v1","round_robin_order":[136,156,139,141,145,158,127,131,124,120,125,121,122,153,130,147,142,126,134,148,144,119,146,135,155,128,118,149,123,150,140,137,143,154,161,151,138,157,160,133,132,152,129,159],"bye_ids":[]}	tranca-partida-6-11-classificatoria-3-2	finalizado	132	18	2026-09-14 19:24:30.286545	156	\N	1
307	11	6	E2-R3-J2	2026-09-17 17:09:35.915354	\N	159	128	A	\N	\N	classificatoria	3	\N	\N	1570	1490	{"generated_by":"tranca_second_stage_builder","kind":"second_stage_group","group_key":"A","table_number":2,"slot_a":2,"slot_b":4}	tranca-stage-2-match-6-3-2	finalizado	193	23	2026-09-19 18:50:47.069608	159	\N	2
308	11	6	E2-R3-J3	2026-09-17 17:09:36.13283	\N	135	158	B	\N	\N	classificatoria	3	\N	\N	1430	2430	{"generated_by":"tranca_second_stage_builder","kind":"second_stage_group","group_key":"B","table_number":3,"slot_a":1,"slot_b":3}	tranca-stage-2-match-6-3-3	finalizado	194	23	2026-09-19 18:52:04.724963	158	\N	2
312	11	6	E2-R3-J7	2026-09-17 17:09:37.112259	\N	141	152	D	\N	\N	classificatoria	3	\N	\N	1330	1600	{"generated_by":"tranca_second_stage_builder","kind":"second_stage_group","group_key":"D","table_number":7,"slot_a":1,"slot_b":3}	tranca-stage-2-match-6-3-7	finalizado	198	23	2026-09-19 18:53:29.750541	152	\N	2
311	11	6	E2-R3-J6	2026-09-17 17:09:36.895391	\N	121	142	C	\N	\N	classificatoria	3	\N	\N	670	2020	{"generated_by":"tranca_second_stage_builder","kind":"second_stage_group","group_key":"C","table_number":6,"slot_a":2,"slot_b":4}	tranca-stage-2-match-6-3-6	finalizado	197	23	2026-09-19 18:54:39.134423	142	\N	2
310	11	6	E2-R3-J5	2026-09-17 17:09:36.624011	\N	144	123	C	\N	\N	classificatoria	3	\N	\N	2480	2430	{"generated_by":"tranca_second_stage_builder","kind":"second_stage_group","group_key":"C","table_number":5,"slot_a":1,"slot_b":3}	tranca-stage-2-match-6-3-5	finalizado	196	23	2026-09-19 18:56:16.575289	144	\N	2
309	11	6	E2-R3-J4	2026-09-17 17:09:36.406217	\N	145	148	B	\N	\N	classificatoria	3	\N	\N	1920	870	{"generated_by":"tranca_second_stage_builder","kind":"second_stage_group","group_key":"B","table_number":4,"slot_a":2,"slot_b":4}	tranca-stage-2-match-6-3-4	finalizado	195	23	2026-09-19 18:57:34.434607	145	\N	2
313	11	6	E2-R3-J8	2026-09-17 17:09:37.382175	\N	126	139	D	\N	\N	classificatoria	3	\N	\N	620	2170	{"generated_by":"tranca_second_stage_builder","kind":"second_stage_group","group_key":"D","table_number":8,"slot_a":2,"slot_b":4}	tranca-stage-2-match-6-3-8	finalizado	199	23	2026-09-19 19:01:08.084077	139	\N	2
306	11	6	E2-R3-J1	2026-09-17 17:09:35.645033	\N	156	118	A	\N	\N	classificatoria	3	\N	\N	1260	2200	{"generated_by":"tranca_second_stage_builder","kind":"second_stage_group","group_key":"A","table_number":1,"slot_a":1,"slot_b":3}	tranca-stage-2-match-6-3-1	finalizado	192	23	2026-09-19 19:03:07.08798	118	\N	2
\.


--
-- Data for Name: tranca_partida_maos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."tranca_partida_maos" ("id", "batida_a", "batida_b", "canastra_limpa_a", "canastra_limpa_b", "canastra_suja_a", "canastra_suja_b", "championship_id", "created_at", "desconto_a", "desconto_b", "numero", "observacoes", "pontos_a", "pontos_b", "source_data", "source_id", "tranca_partida_id", "tres_vermelho_a", "tres_vermelho_b", "updated_at") FROM stdin;
154	f	f	f	f	f	f	6	2026-09-14 18:47:07.682321	0	0	1	\N	320	680	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-1-11-mao-1	207	f	f	2026-09-14 18:47:07.682321
155	f	f	f	f	f	f	6	2026-09-14 18:47:07.845327	0	0	2	\N	440	270	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-1-11-mao-2	207	f	f	2026-09-14 18:47:07.845327
156	f	f	f	f	f	f	6	2026-09-14 18:47:08.008272	0	0	3	\N	840	-90	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-1-11-mao-3	207	f	f	2026-09-14 18:47:08.008272
157	f	f	f	f	f	f	6	2026-09-14 18:47:08.173001	0	0	4	\N	700	560	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-1-11-mao-4	207	f	f	2026-09-14 18:47:08.173001
178	f	f	f	f	f	f	6	2026-09-14 18:59:28.575701	0	0	1	\N	1050	840	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-1-19-mao-1	215	f	f	2026-09-14 18:59:28.575701
179	f	f	f	f	f	f	6	2026-09-14 18:59:28.73974	0	0	2	\N	610	590	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-1-19-mao-2	215	f	f	2026-09-14 18:59:28.73974
180	f	f	f	f	f	f	6	2026-09-14 18:59:28.902832	0	0	3	\N	910	290	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-1-19-mao-3	215	f	f	2026-09-14 18:59:28.902832
181	f	f	f	f	f	f	6	2026-09-14 18:59:29.065712	0	0	4	\N	830	640	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-1-19-mao-4	215	f	f	2026-09-14 18:59:29.065712
186	f	f	f	f	f	f	6	2026-09-14 19:03:07.287301	0	0	1	\N	770	650	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-1-22-mao-1	218	f	f	2026-09-14 19:03:07.287301
187	f	f	f	f	f	f	6	2026-09-14 19:03:07.447042	0	0	2	\N	400	830	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-1-22-mao-2	218	f	f	2026-09-14 19:03:07.447042
188	f	f	f	f	f	f	6	2026-09-14 19:03:07.605179	0	0	3	\N	760	1250	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-1-22-mao-3	218	f	f	2026-09-14 19:03:07.605179
189	f	f	f	f	f	f	6	2026-09-14 19:03:07.763161	0	0	4	\N	0	0	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-1-22-mao-4	218	f	f	2026-09-14 19:03:07.763161
210	f	f	f	f	f	f	6	2026-09-19 17:31:58.987282	0	0	1	\N	940	-20	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-1-5-mao-1	294	f	f	2026-09-19 17:31:58.987282
211	f	f	f	f	f	f	6	2026-09-19 17:31:59.199198	0	0	2	\N	330	1130	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-1-5-mao-2	294	f	f	2026-09-19 17:31:59.199198
212	f	f	f	f	f	f	6	2026-09-19 17:31:59.359741	0	0	3	\N	910	170	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-1-5-mao-3	294	f	f	2026-09-19 17:31:59.359741
213	f	f	f	f	f	f	6	2026-09-19 17:31:59.520044	0	0	4	\N	0	0	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-1-5-mao-4	294	f	f	2026-09-19 17:31:59.520044
214	f	f	f	f	f	f	6	2026-09-19 17:31:59.696799	0	0	5	\N	0	0	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-1-5-mao-5	294	f	f	2026-09-19 17:31:59.696799
215	f	f	f	f	f	f	6	2026-09-19 17:35:00.903403	0	0	1	\N	770	540	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-1-8-mao-1	297	f	f	2026-09-19 17:35:00.903403
216	f	f	f	f	f	f	6	2026-09-19 17:35:01.076051	0	0	2	\N	630	900	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-1-8-mao-2	297	f	f	2026-09-19 17:35:01.076051
217	f	f	f	f	f	f	6	2026-09-19 17:35:01.239474	0	0	3	\N	120	1030	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-1-8-mao-3	297	f	f	2026-09-19 17:35:01.239474
218	f	f	f	f	f	f	6	2026-09-19 17:35:01.403789	0	0	4	\N	0	0	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-1-8-mao-4	297	f	f	2026-09-19 17:35:01.403789
219	f	f	f	f	f	f	6	2026-09-19 17:35:01.581435	0	0	5	\N	0	0	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-1-8-mao-5	297	f	f	2026-09-19 17:35:01.581435
220	f	f	f	f	f	f	6	2026-09-19 17:38:06.89449	0	0	1	\N	270	790	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-1-6-mao-1	295	f	f	2026-09-19 17:38:06.89449
221	f	f	f	f	f	f	6	2026-09-19 17:38:07.064431	0	0	2	\N	330	950	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-1-6-mao-2	295	f	f	2026-09-19 17:38:07.064431
222	f	f	f	f	f	f	6	2026-09-19 17:38:07.227581	0	0	3	\N	560	240	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-1-6-mao-3	295	f	f	2026-09-19 17:38:07.227581
223	f	f	f	f	f	f	6	2026-09-19 17:38:07.390475	0	0	4	\N	0	0	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-1-6-mao-4	295	f	f	2026-09-19 17:38:07.390475
224	f	f	f	f	f	f	6	2026-09-19 17:38:07.55293	0	0	5	\N	0	0	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-1-6-mao-5	295	f	f	2026-09-19 17:38:07.55293
225	f	f	f	f	f	f	6	2026-09-19 17:39:00.350076	0	0	1	\N	510	970	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-1-1-mao-1	290	f	f	2026-09-19 17:39:00.350076
226	f	f	f	f	f	f	6	2026-09-19 17:39:00.515257	0	0	2	\N	560	170	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-1-1-mao-2	290	f	f	2026-09-19 17:39:00.515257
227	f	f	f	f	f	f	6	2026-09-19 17:39:00.678936	0	0	3	\N	460	550	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-1-1-mao-3	290	f	f	2026-09-19 17:39:00.678936
228	f	f	f	f	f	f	6	2026-09-19 17:39:00.843541	0	0	4	\N	0	0	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-1-1-mao-4	290	f	f	2026-09-19 17:39:00.843541
229	f	f	f	f	f	f	6	2026-09-19 17:39:01.005853	0	0	5	\N	0	0	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-1-1-mao-5	290	f	f	2026-09-19 17:39:01.005853
260	f	f	f	f	f	f	6	2026-09-19 18:14:34.84921	0	0	1	\N	-20	710	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-2-4-mao-1	301	f	f	2026-09-19 18:14:34.84921
261	f	f	f	f	f	f	6	2026-09-19 18:14:35.013376	0	0	2	\N	460	850	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-2-4-mao-2	301	f	f	2026-09-19 18:14:35.013376
262	f	f	f	f	f	f	6	2026-09-19 18:14:35.175583	0	0	3	\N	610	510	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-2-4-mao-3	301	f	f	2026-09-19 18:14:35.175583
263	f	f	f	f	f	f	6	2026-09-19 18:14:35.336951	0	0	4	\N	0	0	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-2-4-mao-4	301	f	f	2026-09-19 18:14:35.336951
264	f	f	f	f	f	f	6	2026-09-19 18:14:35.499351	0	0	5	\N	0	0	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-2-4-mao-5	301	f	f	2026-09-19 18:14:35.499351
265	f	f	f	f	f	f	6	2026-09-19 18:16:24.224407	0	0	1	\N	750	810	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-2-8-mao-1	305	f	f	2026-09-19 18:16:24.224407
266	f	f	f	f	f	f	6	2026-09-19 18:16:24.393157	0	0	2	\N	470	730	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-2-8-mao-2	305	f	f	2026-09-19 18:16:24.393157
267	f	f	f	f	f	f	6	2026-09-19 18:16:24.565073	0	0	3	\N	170	650	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-2-8-mao-3	305	f	f	2026-09-19 18:16:24.565073
268	f	f	f	f	f	f	6	2026-09-19 18:16:24.72653	0	0	4	\N	0	0	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-2-8-mao-4	305	f	f	2026-09-19 18:16:24.72653
269	f	f	f	f	f	f	6	2026-09-19 18:16:24.888702	0	0	5	\N	0	0	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-2-8-mao-5	305	f	f	2026-09-19 18:16:24.888702
275	f	f	f	f	f	f	6	2026-09-19 18:20:16.294464	0	0	1	\N	610	360	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-2-2-mao-1	299	f	f	2026-09-19 18:20:16.294464
276	f	f	f	f	f	f	6	2026-09-19 18:20:16.458114	0	0	2	\N	-180	710	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-2-2-mao-2	299	f	f	2026-09-19 18:20:16.458114
158	f	f	f	f	f	f	6	2026-09-14 18:49:17.282887	0	0	1	\N	740	330	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-1-12-mao-1	208	f	f	2026-09-14 18:49:17.282887
159	f	f	f	f	f	f	6	2026-09-14 18:49:17.435144	0	0	2	\N	40	500	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-1-12-mao-2	208	f	f	2026-09-14 18:49:17.435144
160	f	f	f	f	f	f	6	2026-09-14 18:49:17.581853	0	0	3	\N	530	130	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-1-12-mao-3	208	f	f	2026-09-14 18:49:17.581853
161	f	f	f	f	f	f	6	2026-09-14 18:49:17.728496	0	0	4	\N	450	150	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-1-12-mao-4	208	f	f	2026-09-14 18:49:17.728496
182	f	f	f	f	f	f	6	2026-09-14 19:01:36.496326	0	0	1	\N	440	450	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-1-20-mao-1	216	f	f	2026-09-14 19:01:36.496326
183	f	f	f	f	f	f	6	2026-09-14 19:01:36.663238	0	0	2	\N	-170	620	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-1-20-mao-2	216	f	f	2026-09-14 19:01:36.663238
184	f	f	f	f	f	f	6	2026-09-14 19:01:36.82231	0	0	3	\N	-250	840	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-1-20-mao-3	216	f	f	2026-09-14 19:01:36.82231
185	f	f	f	f	f	f	6	2026-09-14 19:01:36.98036	0	0	4	\N	620	540	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-1-20-mao-4	216	f	f	2026-09-14 19:01:36.98036
190	f	f	f	f	f	f	6	2026-09-14 19:04:48.118177	0	0	1	\N	1050	900	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-1-21-mao-1	217	f	f	2026-09-14 19:04:48.118177
191	f	f	f	f	f	f	6	2026-09-14 19:04:48.277091	0	0	2	\N	1280	350	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-1-21-mao-2	217	f	f	2026-09-14 19:04:48.277091
192	f	f	f	f	f	f	6	2026-09-14 19:04:48.436308	0	0	3	\N	320	1230	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-1-21-mao-3	217	f	f	2026-09-14 19:04:48.436308
193	f	f	f	f	f	f	6	2026-09-14 19:04:48.59774	0	0	4	\N	230	890	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-1-21-mao-4	217	f	f	2026-09-14 19:04:48.59774
230	f	f	f	f	f	f	6	2026-09-19 17:40:27.753457	0	0	1	\N	680	-140	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-1-3-mao-1	292	f	f	2026-09-19 17:40:27.753457
231	f	f	f	f	f	f	6	2026-09-19 17:40:27.919913	0	0	2	\N	570	-60	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-1-3-mao-2	292	f	f	2026-09-19 17:40:27.919913
232	f	f	f	f	f	f	6	2026-09-19 17:40:28.082195	0	0	3	\N	730	820	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-1-3-mao-3	292	f	f	2026-09-19 17:40:28.082195
233	f	f	f	f	f	f	6	2026-09-19 17:40:28.24429	0	0	4	\N	0	0	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-1-3-mao-4	292	f	f	2026-09-19 17:40:28.24429
234	f	f	f	f	f	f	6	2026-09-19 17:40:28.406494	0	0	5	\N	0	0	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-1-3-mao-5	292	f	f	2026-09-19 17:40:28.406494
235	f	f	f	f	f	f	6	2026-09-19 17:41:30.281886	0	0	1	\N	760	440	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-1-2-mao-1	291	f	f	2026-09-19 17:41:30.281886
236	f	f	f	f	f	f	6	2026-09-19 17:41:30.444638	0	0	2	\N	730	960	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-1-2-mao-2	291	f	f	2026-09-19 17:41:30.444638
237	f	f	f	f	f	f	6	2026-09-19 17:41:30.612239	0	0	3	\N	730	310	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-1-2-mao-3	291	f	f	2026-09-19 17:41:30.612239
238	f	f	f	f	f	f	6	2026-09-19 17:41:30.776504	0	0	4	\N	0	0	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-1-2-mao-4	291	f	f	2026-09-19 17:41:30.776504
239	f	f	f	f	f	f	6	2026-09-19 17:41:30.94417	0	0	5	\N	0	0	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-1-2-mao-5	291	f	f	2026-09-19 17:41:30.94417
240	f	f	f	f	f	f	6	2026-09-19 17:42:14.908111	0	0	1	\N	1030	840	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-1-4-mao-1	293	f	f	2026-09-19 17:42:14.908111
241	f	f	f	f	f	f	6	2026-09-19 17:42:15.079794	0	0	2	\N	150	780	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-1-4-mao-2	293	f	f	2026-09-19 17:42:15.079794
242	f	f	f	f	f	f	6	2026-09-19 17:42:15.242131	0	0	3	\N	100	390	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-1-4-mao-3	293	f	f	2026-09-19 17:42:15.242131
243	f	f	f	f	f	f	6	2026-09-19 17:42:15.404182	0	0	4	\N	0	0	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-1-4-mao-4	293	f	f	2026-09-19 17:42:15.404182
244	f	f	f	f	f	f	6	2026-09-19 17:42:15.565818	0	0	5	\N	0	0	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-1-4-mao-5	293	f	f	2026-09-19 17:42:15.565818
245	f	f	f	f	f	f	6	2026-09-19 17:43:30.004623	0	0	1	\N	420	270	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-1-7-mao-1	296	f	f	2026-09-19 17:43:30.004623
246	f	f	f	f	f	f	6	2026-09-19 17:43:30.175851	0	0	2	\N	170	930	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-1-7-mao-2	296	f	f	2026-09-19 17:43:30.175851
247	f	f	f	f	f	f	6	2026-09-19 17:43:30.33782	0	0	3	\N	750	60	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-1-7-mao-3	296	f	f	2026-09-19 17:43:30.33782
248	f	f	f	f	f	f	6	2026-09-19 17:43:30.500129	0	0	4	\N	0	0	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-1-7-mao-4	296	f	f	2026-09-19 17:43:30.500129
249	f	f	f	f	f	f	6	2026-09-19 17:43:30.663732	0	0	5	\N	0	0	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-1-7-mao-5	296	f	f	2026-09-19 17:43:30.663732
270	f	f	f	f	f	f	6	2026-09-19 18:18:52.192093	0	0	1	\N	1080	590	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-2-3-mao-1	300	f	f	2026-09-19 18:18:52.192093
271	f	f	f	f	f	f	6	2026-09-19 18:18:52.356916	0	0	2	\N	680	950	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-2-3-mao-2	300	f	f	2026-09-19 18:18:52.356916
272	f	f	f	f	f	f	6	2026-09-19 18:18:52.51805	0	0	3	\N	110	-190	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-2-3-mao-3	300	f	f	2026-09-19 18:18:52.51805
273	f	f	f	f	f	f	6	2026-09-19 18:18:52.679351	0	0	4	\N	0	0	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-2-3-mao-4	300	f	f	2026-09-19 18:18:52.679351
274	f	f	f	f	f	f	6	2026-09-19 18:18:52.84034	0	0	5	\N	0	0	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-2-3-mao-5	300	f	f	2026-09-19 18:18:52.84034
280	f	f	f	f	f	f	6	2026-09-19 18:21:16.565552	0	0	1	\N	810	-240	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-2-1-mao-1	298	f	f	2026-09-19 18:21:16.565552
281	f	f	f	f	f	f	6	2026-09-19 18:21:16.727663	0	0	2	\N	400	410	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-2-1-mao-2	298	f	f	2026-09-19 18:21:16.727663
282	f	f	f	f	f	f	6	2026-09-19 18:21:16.888982	0	0	3	\N	580	410	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-2-1-mao-3	298	f	f	2026-09-19 18:21:16.888982
283	f	f	f	f	f	f	6	2026-09-19 18:21:17.050427	0	0	4	\N	0	0	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-2-1-mao-4	298	f	f	2026-09-19 18:21:17.050427
284	f	f	f	f	f	f	6	2026-09-19 18:21:17.211819	0	0	5	\N	0	0	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-2-1-mao-5	298	f	f	2026-09-19 18:21:17.211819
290	f	f	f	f	f	f	6	2026-09-19 18:50:45.799911	0	0	1	\N	610	960	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-3-2-mao-1	307	f	f	2026-09-19 18:50:45.799911
291	f	f	f	f	f	f	6	2026-09-19 18:50:45.984816	0	0	2	\N	960	530	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-3-2-mao-2	307	f	f	2026-09-19 18:50:45.984816
162	f	f	f	f	f	f	6	2026-09-14 18:50:48.12454	0	0	1	\N	710	210	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-1-13-mao-1	209	f	f	2026-09-14 18:50:48.12454
163	f	f	f	f	f	f	6	2026-09-14 18:50:48.332013	0	0	2	\N	900	900	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-1-13-mao-2	209	f	f	2026-09-14 18:50:48.332013
164	f	f	f	f	f	f	6	2026-09-14 18:50:48.482182	0	0	3	\N	610	440	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-1-13-mao-3	209	f	f	2026-09-14 18:50:48.482182
165	f	f	f	f	f	f	6	2026-09-14 18:50:48.632032	0	0	4	\N	0	0	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-1-13-mao-4	209	f	f	2026-09-14 18:50:48.632032
166	f	f	f	f	f	f	6	2026-09-14 18:52:35.332505	0	0	1	\N	970	70	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-1-14-mao-1	210	f	f	2026-09-14 18:52:35.332505
167	f	f	f	f	f	f	6	2026-09-14 18:52:35.480724	0	0	2	\N	820	40	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-1-14-mao-2	210	f	f	2026-09-14 18:52:35.480724
168	f	f	f	f	f	f	6	2026-09-14 18:52:35.627402	0	0	3	\N	600	-160	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-1-14-mao-3	210	f	f	2026-09-14 18:52:35.627402
169	f	f	f	f	f	f	6	2026-09-14 18:52:35.776314	0	0	4	\N	460	-300	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-1-14-mao-4	210	f	f	2026-09-14 18:52:35.776314
170	f	f	f	f	f	f	6	2026-09-14 18:54:29.084722	0	0	1	\N	680	630	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-1-17-mao-1	213	f	f	2026-09-14 18:54:29.084722
171	f	f	f	f	f	f	6	2026-09-14 18:54:29.247548	0	0	2	\N	10	560	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-1-17-mao-2	213	f	f	2026-09-14 18:54:29.247548
172	f	f	f	f	f	f	6	2026-09-14 18:54:29.410509	0	0	3	\N	610	410	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-1-17-mao-3	213	f	f	2026-09-14 18:54:29.410509
173	f	f	f	f	f	f	6	2026-09-14 18:54:29.57864	0	0	4	\N	880	790	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-1-17-mao-4	213	f	f	2026-09-14 18:54:29.57864
174	f	f	f	f	f	f	6	2026-09-14 18:56:48.282462	0	0	1	\N	380	550	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-1-18-mao-1	214	f	f	2026-09-14 18:56:48.282462
175	f	f	f	f	f	f	6	2026-09-14 18:56:48.445186	0	0	2	\N	840	800	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-1-18-mao-2	214	f	f	2026-09-14 18:56:48.445186
177	f	f	f	f	f	f	6	2026-09-14 18:56:48.770661	0	0	4	\N	1160	1210	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-1-18-mao-4	214	f	f	2026-09-14 18:56:48.770661
250	f	f	f	f	f	f	6	2026-09-19 18:09:24.925844	0	0	1	\N	440	640	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-2-5-mao-1	302	f	f	2026-09-19 18:09:24.925844
176	f	f	f	f	f	f	6	2026-09-14 18:56:48.607687	0	0	3	\N	-310	730	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-1-18-mao-3	214	f	f	2026-09-14 18:57:44.094462
114	f	f	f	f	f	f	6	2026-09-14 15:07:20.715187	0	0	1	\N	-410	1070	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-2-20-mao-1	238	f	f	2026-09-14 19:11:39.132285
115	f	f	f	f	f	f	6	2026-09-14 15:07:20.882507	0	0	2	\N	830	-160	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-2-20-mao-2	238	f	f	2026-09-14 19:11:39.243721
86	f	f	f	f	f	f	6	2026-09-14 14:41:50.337171	0	0	1	\N	530	-340	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-2-3-mao-1	221	f	f	2026-09-14 14:41:50.337171
87	f	f	f	f	f	f	6	2026-09-14 14:41:51.109578	0	0	2	\N	560	-170	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-2-3-mao-2	221	f	f	2026-09-14 14:41:51.109578
88	f	f	f	f	f	f	6	2026-09-14 14:41:51.305609	0	0	3	\N	70	860	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-2-3-mao-3	221	f	f	2026-09-14 14:41:51.305609
89	f	f	f	f	f	f	6	2026-09-14 14:41:51.498251	0	0	4	\N	320	380	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-2-3-mao-4	221	f	f	2026-09-14 14:41:51.498251
90	f	f	f	f	f	f	6	2026-09-14 14:47:49.958318	0	0	1	\N	920	570	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-2-19-mao-1	237	f	f	2026-09-14 14:47:49.958318
91	f	f	f	f	f	f	6	2026-09-14 14:47:50.191597	0	0	2	\N	1360	300	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-2-19-mao-2	237	f	f	2026-09-14 14:47:50.191597
92	f	f	f	f	f	f	6	2026-09-14 14:47:50.351225	0	0	3	\N	780	360	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-2-19-mao-3	237	f	f	2026-09-14 14:47:50.351225
93	f	f	f	f	f	f	6	2026-09-14 14:47:50.520341	0	0	4	\N	940	420	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-2-19-mao-4	237	f	f	2026-09-14 14:47:50.520341
98	f	f	f	f	f	f	6	2026-09-14 14:53:43.317565	0	0	1	\N	830	550	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-3-13-mao-1	253	f	f	2026-09-14 14:53:43.317565
116	f	f	f	f	f	f	6	2026-09-14 15:07:21.052149	0	0	3	\N	890	660	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-2-20-mao-3	238	f	f	2026-09-14 19:11:39.297435
117	f	f	f	f	f	f	6	2026-09-14 15:07:21.214431	0	0	4	\N	1500	1090	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-2-20-mao-4	238	f	f	2026-09-14 19:11:39.350684
251	f	f	f	f	f	f	6	2026-09-19 18:09:25.102616	0	0	2	\N	390	1390	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-2-5-mao-2	302	f	f	2026-09-19 18:09:25.102616
252	f	f	f	f	f	f	6	2026-09-19 18:09:25.268264	0	0	3	\N	0	0	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-2-5-mao-3	302	f	f	2026-09-19 18:09:25.268264
253	f	f	f	f	f	f	6	2026-09-19 18:09:25.433195	0	0	4	\N	0	0	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-2-5-mao-4	302	f	f	2026-09-19 18:09:25.433195
254	f	f	f	f	f	f	6	2026-09-19 18:09:25.595216	0	0	5	\N	0	0	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-2-5-mao-5	302	f	f	2026-09-19 18:09:25.595216
277	f	f	f	f	f	f	6	2026-09-19 18:20:16.627685	0	0	3	\N	200	-80	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-2-2-mao-3	299	f	f	2026-09-19 18:20:16.627685
278	f	f	f	f	f	f	6	2026-09-19 18:20:16.789208	0	0	4	\N	0	0	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-2-2-mao-4	299	f	f	2026-09-19 18:20:16.789208
279	f	f	f	f	f	f	6	2026-09-19 18:20:16.950346	0	0	5	\N	0	0	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-2-2-mao-5	299	f	f	2026-09-19 18:20:16.950346
292	f	f	f	f	f	f	6	2026-09-19 18:50:46.147708	0	0	3	\N	0	0	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-3-2-mao-3	307	f	f	2026-09-19 18:50:46.147708
293	f	f	f	f	f	f	6	2026-09-19 18:50:46.309634	0	0	4	\N	0	0	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-3-2-mao-4	307	f	f	2026-09-19 18:50:46.309634
294	f	f	f	f	f	f	6	2026-09-19 18:50:46.471012	0	0	5	\N	0	0	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-3-2-mao-5	307	f	f	2026-09-19 18:50:46.471012
297	f	f	f	f	f	f	6	2026-09-19 18:52:03.805138	0	0	3	\N	420	690	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-3-3-mao-3	308	f	f	2026-09-19 18:52:03.805138
298	f	f	f	f	f	f	6	2026-09-19 18:52:03.966691	0	0	4	\N	0	0	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-3-3-mao-4	308	f	f	2026-09-19 18:52:03.966691
99	f	f	f	f	f	f	6	2026-09-14 14:53:43.484917	0	0	2	\N	590	610	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-3-13-mao-2	253	f	f	2026-09-14 14:53:43.484917
100	f	f	f	f	f	f	6	2026-09-14 14:53:43.648213	0	0	3	\N	520	1020	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-3-13-mao-3	253	f	f	2026-09-14 14:53:43.648213
101	f	f	f	f	f	f	6	2026-09-14 14:53:43.8067	0	0	4	\N	780	-410	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-3-13-mao-4	253	f	f	2026-09-14 14:53:43.8067
102	f	f	f	f	f	f	6	2026-09-14 14:56:10.958235	0	0	1	\N	830	500	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-3-20-mao-1	260	f	f	2026-09-14 14:56:10.958235
103	f	f	f	f	f	f	6	2026-09-14 14:56:11.130623	0	0	2	\N	-160	820	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-3-20-mao-2	260	f	f	2026-09-14 14:56:11.130623
104	f	f	f	f	f	f	6	2026-09-14 14:56:11.292079	0	0	3	\N	890	580	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-3-20-mao-3	260	f	f	2026-09-14 14:56:11.292079
105	f	f	f	f	f	f	6	2026-09-14 14:56:11.453996	0	0	4	\N	400	480	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-3-20-mao-4	260	f	f	2026-09-14 14:56:11.453996
106	f	f	f	f	f	f	6	2026-09-14 14:59:15.294081	0	0	1	\N	980	310	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-3-4-mao-1	244	f	f	2026-09-14 14:59:15.294081
107	f	f	f	f	f	f	6	2026-09-14 14:59:15.451469	0	0	2	\N	730	470	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-3-4-mao-2	244	f	f	2026-09-14 14:59:15.451469
108	f	f	f	f	f	f	6	2026-09-14 14:59:15.607873	0	0	3	\N	320	740	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-3-4-mao-3	244	f	f	2026-09-14 14:59:15.607873
109	f	f	f	f	f	f	6	2026-09-14 14:59:15.764282	0	0	4	\N	1030	410	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-3-4-mao-4	244	f	f	2026-09-14 14:59:15.764282
118	f	f	f	f	f	f	6	2026-09-14 15:10:03.584598	0	0	1	\N	1030	300	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-3-11-mao-1	251	f	f	2026-09-14 15:10:03.584598
119	f	f	f	f	f	f	6	2026-09-14 15:10:03.741719	0	0	2	\N	500	550	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-3-11-mao-2	251	f	f	2026-09-14 15:10:03.741719
120	f	f	f	f	f	f	6	2026-09-14 15:10:03.898312	0	0	3	\N	1210	310	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-3-11-mao-3	251	f	f	2026-09-14 15:10:03.898312
121	f	f	f	f	f	f	6	2026-09-14 15:10:04.054991	0	0	4	\N	-130	-50	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-3-11-mao-4	251	f	f	2026-09-14 15:10:04.054991
82	f	f	f	f	f	f	6	2026-09-14 14:36:04.496309	0	0	1	\N	860	420	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-2-1-mao-1	219	f	f	2026-09-14 15:13:27.210615
83	f	f	f	f	f	f	6	2026-09-14 14:36:04.69004	0	0	2	\N	1120	190	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-2-1-mao-2	219	f	f	2026-09-14 15:13:27.282811
84	f	f	f	f	f	f	6	2026-09-14 14:36:04.851291	0	0	3	\N	830	710	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-2-1-mao-3	219	f	f	2026-09-14 15:13:27.335499
85	f	f	f	f	f	f	6	2026-09-14 14:36:05.014859	0	0	4	\N	720	420	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-2-1-mao-4	219	f	f	2026-09-14 15:13:27.387886
122	f	f	f	f	f	f	6	2026-09-14 15:46:48.100464	0	0	1	\N	980	250	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-2-4-mao-1	222	f	f	2026-09-14 15:46:48.100464
123	f	f	f	f	f	f	6	2026-09-14 15:46:48.282121	0	0	2	\N	580	130	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-2-4-mao-2	222	f	f	2026-09-14 15:46:48.282121
124	f	f	f	f	f	f	6	2026-09-14 15:46:48.450169	0	0	3	\N	180	-120	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-2-4-mao-3	222	f	f	2026-09-14 15:46:48.450169
125	f	f	f	f	f	f	6	2026-09-14 15:46:48.618134	0	0	4	\N	1180	-30	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-2-4-mao-4	222	f	f	2026-09-14 15:46:48.618134
9	f	f	f	f	f	f	6	2026-09-12 20:21:35.771642	0	0	1	\N	480	470	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-1-1-mao-1	197	f	f	2026-09-14 17:43:29.611077
10	f	f	f	f	f	f	6	2026-09-12 20:21:36.296922	0	0	2	\N	650	310	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-1-1-mao-2	197	f	f	2026-09-14 17:43:29.726679
11	f	f	f	f	f	f	6	2026-09-12 20:21:36.568038	0	0	3	\N	650	540	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-1-1-mao-3	197	f	f	2026-09-14 17:43:29.781309
12	f	f	f	f	f	f	6	2026-09-12 20:21:36.761487	0	0	4	\N	560	370	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-1-1-mao-4	197	f	f	2026-09-14 17:43:29.835364
126	f	f	f	f	f	f	6	2026-09-14 18:21:17.08015	0	0	1	\N	370	740	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-1-4-mao-1	200	f	f	2026-09-14 18:21:17.08015
127	f	f	f	f	f	f	6	2026-09-14 18:21:17.263353	0	0	2	\N	490	790	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-1-4-mao-2	200	f	f	2026-09-14 18:21:17.263353
128	f	f	f	f	f	f	6	2026-09-14 18:21:17.43095	0	0	3	\N	410	310	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-1-4-mao-3	200	f	f	2026-09-14 18:21:17.43095
129	f	f	f	f	f	f	6	2026-09-14 18:21:17.612534	0	0	4	\N	490	620	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-1-4-mao-4	200	f	f	2026-09-14 18:21:17.612534
130	f	f	f	f	f	f	6	2026-09-14 18:26:38.610059	0	0	1	\N	800	730	{"generated_by":"tranca_competition_flow"}	tranca-partida-manual-420be330-mao-1	263	f	f	2026-09-14 18:26:38.610059
131	f	f	f	f	f	f	6	2026-09-14 18:26:38.773105	0	0	2	\N	590	-190	{"generated_by":"tranca_competition_flow"}	tranca-partida-manual-420be330-mao-2	263	f	f	2026-09-14 18:26:38.773105
132	f	f	f	f	f	f	6	2026-09-14 18:26:38.935019	0	0	3	\N	1030	610	{"generated_by":"tranca_competition_flow"}	tranca-partida-manual-420be330-mao-3	263	f	f	2026-09-14 18:26:38.935019
133	f	f	f	f	f	f	6	2026-09-14 18:26:39.097284	0	0	4	\N	940	680	{"generated_by":"tranca_competition_flow"}	tranca-partida-manual-420be330-mao-4	263	f	f	2026-09-14 18:26:39.097284
134	f	f	f	f	f	f	6	2026-09-14 18:29:34.744251	0	0	1	\N	550	900	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-1-3-mao-1	199	f	f	2026-09-14 18:29:34.744251
135	f	f	f	f	f	f	6	2026-09-14 18:29:34.909571	0	0	2	\N	930	1160	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-1-3-mao-2	199	f	f	2026-09-14 18:29:34.909571
136	f	f	f	f	f	f	6	2026-09-14 18:29:35.074113	0	0	3	\N	540	640	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-1-3-mao-3	199	f	f	2026-09-14 18:29:35.074113
137	f	f	f	f	f	f	6	2026-09-14 18:29:35.237386	0	0	4	\N	-90	560	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-1-3-mao-4	199	f	f	2026-09-14 18:29:35.237386
138	f	f	f	f	f	f	6	2026-09-14 18:33:21.217615	0	0	1	\N	850	260	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-1-7-mao-1	203	f	f	2026-09-14 18:33:21.217615
139	f	f	f	f	f	f	6	2026-09-14 18:33:21.379271	0	0	2	\N	600	930	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-1-7-mao-2	203	f	f	2026-09-14 18:33:21.379271
140	f	f	f	f	f	f	6	2026-09-14 18:33:21.538447	0	0	3	\N	-180	650	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-1-7-mao-3	203	f	f	2026-09-14 18:33:21.538447
141	f	f	f	f	f	f	6	2026-09-14 18:33:21.69815	0	0	4	\N	930	110	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-1-7-mao-4	203	f	f	2026-09-14 18:33:21.69815
142	f	f	f	f	f	f	6	2026-09-14 18:36:00.755022	0	0	1	\N	-30	460	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-1-8-mao-1	204	f	f	2026-09-14 18:36:00.755022
143	f	f	f	f	f	f	6	2026-09-14 18:36:00.914702	0	0	2	\N	680	770	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-1-8-mao-2	204	f	f	2026-09-14 18:36:00.914702
144	f	f	f	f	f	f	6	2026-09-14 18:36:01.063503	0	0	3	\N	810	370	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-1-8-mao-3	204	f	f	2026-09-14 18:36:01.063503
145	f	f	f	f	f	f	6	2026-09-14 18:36:01.221571	0	0	4	\N	190	410	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-1-8-mao-4	204	f	f	2026-09-14 18:36:01.221571
146	f	f	f	f	f	f	6	2026-09-14 18:38:24.075604	0	0	1	\N	460	680	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-1-9-mao-1	205	f	f	2026-09-14 18:38:24.075604
147	f	f	f	f	f	f	6	2026-09-14 18:38:24.224685	0	0	2	\N	630	570	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-1-9-mao-2	205	f	f	2026-09-14 18:38:24.224685
148	f	f	f	f	f	f	6	2026-09-14 18:38:24.371741	0	0	3	\N	400	880	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-1-9-mao-3	205	f	f	2026-09-14 18:38:24.371741
149	f	f	f	f	f	f	6	2026-09-14 18:38:24.519278	0	0	4	\N	1160	500	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-1-9-mao-4	205	f	f	2026-09-14 18:38:24.519278
150	f	f	f	f	f	f	6	2026-09-14 18:41:55.451202	0	0	1	\N	-130	380	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-1-10-mao-1	206	f	f	2026-09-14 18:41:55.451202
151	f	f	f	f	f	f	6	2026-09-14 18:41:55.617173	0	0	2	\N	820	650	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-1-10-mao-2	206	f	f	2026-09-14 18:41:55.617173
152	f	f	f	f	f	f	6	2026-09-14 18:41:55.780298	0	0	3	\N	540	-160	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-1-10-mao-3	206	f	f	2026-09-14 18:41:55.780298
153	f	f	f	f	f	f	6	2026-09-14 18:41:55.943305	0	0	4	\N	-100	320	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-1-10-mao-4	206	f	f	2026-09-14 18:41:55.943305
198	f	f	f	f	f	f	6	2026-09-14 19:19:51.244328	0	0	1	\N	950	280	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-3-1-mao-1	241	f	f	2026-09-14 19:19:51.244328
199	f	f	f	f	f	f	6	2026-09-14 19:19:51.404762	0	0	2	\N	590	350	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-3-1-mao-2	241	f	f	2026-09-14 19:19:51.404762
200	f	f	f	f	f	f	6	2026-09-14 19:19:51.563005	0	0	3	\N	560	760	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-3-1-mao-3	241	f	f	2026-09-14 19:19:51.563005
201	f	f	f	f	f	f	6	2026-09-14 19:19:51.721264	0	0	4	\N	0	410	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-3-1-mao-4	241	f	f	2026-09-14 19:19:51.721264
202	f	f	f	f	f	f	6	2026-09-14 19:24:29.191776	0	0	1	\N	570	450	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-3-2-mao-1	242	f	f	2026-09-14 19:24:29.191776
203	f	f	f	f	f	f	6	2026-09-14 19:24:29.360786	0	0	2	\N	550	910	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-3-2-mao-2	242	f	f	2026-09-14 19:24:29.360786
204	f	f	f	f	f	f	6	2026-09-14 19:24:29.533176	0	0	3	\N	730	-90	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-3-2-mao-3	242	f	f	2026-09-14 19:24:29.533176
205	f	f	f	f	f	f	6	2026-09-14 19:24:29.694488	0	0	4	\N	960	840	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-3-2-mao-4	242	f	f	2026-09-14 19:24:29.694488
206	f	f	f	f	f	f	6	2026-09-14 19:28:16.617352	0	0	1	\N	670	650	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-3-3-mao-1	243	f	f	2026-09-14 19:28:16.617352
207	f	f	f	f	f	f	6	2026-09-14 19:28:16.780461	0	0	2	\N	530	460	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-3-3-mao-2	243	f	f	2026-09-14 19:28:16.780461
208	f	f	f	f	f	f	6	2026-09-14 19:28:16.941082	0	0	3	\N	650	1030	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-3-3-mao-3	243	f	f	2026-09-14 19:28:16.941082
209	f	f	f	f	f	f	6	2026-09-14 19:28:17.102201	0	0	4	\N	690	-160	{"generated_by":"tranca_competition_flow"}	tranca-partida-6-11-classificatoria-3-3-mao-4	243	f	f	2026-09-14 19:28:17.102201
255	f	f	f	f	f	f	6	2026-09-19 18:12:38.405722	0	0	1	\N	650	830	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-2-6-mao-1	303	f	f	2026-09-19 18:12:38.405722
256	f	f	f	f	f	f	6	2026-09-19 18:12:38.578211	0	0	2	\N	520	620	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-2-6-mao-2	303	f	f	2026-09-19 18:12:38.578211
257	f	f	f	f	f	f	6	2026-09-19 18:12:38.739741	0	0	3	\N	470	820	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-2-6-mao-3	303	f	f	2026-09-19 18:12:38.739741
258	f	f	f	f	f	f	6	2026-09-19 18:12:38.901332	0	0	4	\N	0	0	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-2-6-mao-4	303	f	f	2026-09-19 18:12:38.901332
259	f	f	f	f	f	f	6	2026-09-19 18:12:39.064376	0	0	5	\N	0	0	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-2-6-mao-5	303	f	f	2026-09-19 18:12:39.064376
285	f	f	f	f	f	f	6	2026-09-19 18:22:00.940185	0	0	1	\N	760	460	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-2-7-mao-1	304	f	f	2026-09-19 18:22:00.940185
286	f	f	f	f	f	f	6	2026-09-19 18:22:01.103222	0	0	2	\N	720	740	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-2-7-mao-2	304	f	f	2026-09-19 18:22:01.103222
287	f	f	f	f	f	f	6	2026-09-19 18:22:01.265336	0	0	3	\N	810	420	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-2-7-mao-3	304	f	f	2026-09-19 18:22:01.265336
288	f	f	f	f	f	f	6	2026-09-19 18:22:01.475772	0	0	4	\N	0	0	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-2-7-mao-4	304	f	f	2026-09-19 18:22:01.475772
289	f	f	f	f	f	f	6	2026-09-19 18:22:01.637646	0	0	5	\N	0	0	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-2-7-mao-5	304	f	f	2026-09-19 18:22:01.637646
295	f	f	f	f	f	f	6	2026-09-19 18:52:03.481569	0	0	1	\N	670	590	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-3-3-mao-1	308	f	f	2026-09-19 18:52:03.481569
296	f	f	f	f	f	f	6	2026-09-19 18:52:03.6432	0	0	2	\N	340	1150	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-3-3-mao-2	308	f	f	2026-09-19 18:52:03.6432
299	f	f	f	f	f	f	6	2026-09-19 18:52:04.128539	0	0	5	\N	0	0	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-3-3-mao-5	308	f	f	2026-09-19 18:52:04.128539
303	f	f	f	f	f	f	6	2026-09-19 18:52:46.687616	0	0	4	\N	0	0	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-3-7-mao-4	312	f	f	2026-09-19 18:52:46.687616
304	f	f	f	f	f	f	6	2026-09-19 18:52:46.850585	0	0	5	\N	0	0	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-3-7-mao-5	312	f	f	2026-09-19 18:52:46.850585
300	f	f	f	f	f	f	6	2026-09-19 18:52:46.20045	0	0	1	\N	770	740	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-3-7-mao-1	312	f	f	2026-09-19 18:53:28.998846
301	f	f	f	f	f	f	6	2026-09-19 18:52:46.362013	0	0	2	\N	910	120	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-3-7-mao-2	312	f	f	2026-09-19 18:53:29.062655
302	f	f	f	f	f	f	6	2026-09-19 18:52:46.525221	0	0	3	\N	-350	740	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-3-7-mao-3	312	f	f	2026-09-19 18:53:29.139856
305	f	f	f	f	f	f	6	2026-09-19 18:54:37.845023	0	0	1	\N	-180	400	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-3-6-mao-1	311	f	f	2026-09-19 18:54:37.845023
306	f	f	f	f	f	f	6	2026-09-19 18:54:38.058541	0	0	2	\N	410	630	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-3-6-mao-2	311	f	f	2026-09-19 18:54:38.058541
307	f	f	f	f	f	f	6	2026-09-19 18:54:38.220678	0	0	3	\N	440	990	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-3-6-mao-3	311	f	f	2026-09-19 18:54:38.220678
308	f	f	f	f	f	f	6	2026-09-19 18:54:38.382273	0	0	4	\N	0	0	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-3-6-mao-4	311	f	f	2026-09-19 18:54:38.382273
309	f	f	f	f	f	f	6	2026-09-19 18:54:38.544115	0	0	5	\N	0	0	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-3-6-mao-5	311	f	f	2026-09-19 18:54:38.544115
315	f	f	f	f	f	f	6	2026-09-19 18:57:33.191645	0	0	1	\N	230	720	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-3-4-mao-1	309	f	f	2026-09-19 18:57:33.191645
316	f	f	f	f	f	f	6	2026-09-19 18:57:33.357809	0	0	2	\N	900	90	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-3-4-mao-2	309	f	f	2026-09-19 18:57:33.357809
317	f	f	f	f	f	f	6	2026-09-19 18:57:33.51983	0	0	3	\N	790	60	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-3-4-mao-3	309	f	f	2026-09-19 18:57:33.51983
318	f	f	f	f	f	f	6	2026-09-19 18:57:33.681893	0	0	4	\N	0	0	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-3-4-mao-4	309	f	f	2026-09-19 18:57:33.681893
319	f	f	f	f	f	f	6	2026-09-19 18:57:33.845045	0	0	5	\N	0	0	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-3-4-mao-5	309	f	f	2026-09-19 18:57:33.845045
310	f	f	f	f	f	f	6	2026-09-19 18:56:15.334944	0	0	1	\N	610	470	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-3-5-mao-1	310	f	f	2026-09-19 18:56:15.334944
311	f	f	f	f	f	f	6	2026-09-19 18:56:15.499686	0	0	2	\N	580	960	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-3-5-mao-2	310	f	f	2026-09-19 18:56:15.499686
312	f	f	f	f	f	f	6	2026-09-19 18:56:15.661573	0	0	3	\N	630	360	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-3-5-mao-3	310	f	f	2026-09-19 18:56:15.661573
313	f	f	f	f	f	f	6	2026-09-19 18:56:15.822653	0	0	4	\N	660	640	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-3-5-mao-4	310	f	f	2026-09-19 18:56:15.822653
314	f	f	f	f	f	f	6	2026-09-19 18:56:15.983963	0	0	5	\N	0	0	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-3-5-mao-5	310	f	f	2026-09-19 18:56:15.983963
320	f	f	f	f	f	f	6	2026-09-19 19:01:06.800272	0	0	1	\N	280	220	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-3-8-mao-1	313	f	f	2026-09-19 19:01:06.800272
321	f	f	f	f	f	f	6	2026-09-19 19:01:06.983261	0	0	2	\N	160	1160	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-3-8-mao-2	313	f	f	2026-09-19 19:01:06.983261
322	f	f	f	f	f	f	6	2026-09-19 19:01:07.145171	0	0	3	\N	180	790	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-3-8-mao-3	313	f	f	2026-09-19 19:01:07.145171
323	f	f	f	f	f	f	6	2026-09-19 19:01:07.320381	0	0	4	\N	0	0	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-3-8-mao-4	313	f	f	2026-09-19 19:01:07.320381
324	f	f	f	f	f	f	6	2026-09-19 19:01:07.486745	0	0	5	\N	0	0	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-3-8-mao-5	313	f	f	2026-09-19 19:01:07.486745
325	f	f	f	f	f	f	6	2026-09-19 19:03:05.84549	0	0	1	\N	850	510	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-3-1-mao-1	306	f	f	2026-09-19 19:03:05.84549
326	f	f	f	f	f	f	6	2026-09-19 19:03:06.007681	0	0	2	\N	620	830	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-3-1-mao-2	306	f	f	2026-09-19 19:03:06.007681
327	f	f	f	f	f	f	6	2026-09-19 19:03:06.169178	0	0	3	\N	-210	860	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-3-1-mao-3	306	f	f	2026-09-19 19:03:06.169178
328	f	f	f	f	f	f	6	2026-09-19 19:03:06.334762	0	0	4	\N	0	0	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-3-1-mao-4	306	f	f	2026-09-19 19:03:06.334762
329	f	f	f	f	f	f	6	2026-09-19 19:03:06.496995	0	0	5	\N	0	0	{"generated_by":"tranca_competition_flow"}	tranca-stage-2-match-6-3-1-mao-5	306	f	f	2026-09-19 19:03:06.496995
\.


--
-- Data for Name: tranca_settings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."tranca_settings" ("id", "championship_id", "created_at", "format", "rules", "scoring", "source_id", "updated_at") FROM stdin;
\.


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."active_storage_attachments_id_seq"', 7, true);


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."active_storage_blobs_id_seq"', 7, true);


--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."active_storage_variant_records_id_seq"', 1, false);


--
-- Name: athletes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."athletes_id_seq"', 179, true);


--
-- Name: audits_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."audits_id_seq"', 15, true);


--
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."categories_id_seq"', 11, true);


--
-- Name: championship_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."championship_categories_id_seq"', 11, true);


--
-- Name: championship_memberships_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."championship_memberships_id_seq"', 1, false);


--
-- Name: championships_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."championships_id_seq"', 6, true);


--
-- Name: entities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."entities_id_seq"', 149, true);


--
-- Name: invoices_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."invoices_id_seq"', 1, false);


--
-- Name: match_events_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."match_events_id_seq"', 13, true);


--
-- Name: match_participations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."match_participations_id_seq"', 9, true);


--
-- Name: match_reports_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."match_reports_id_seq"', 1, false);


--
-- Name: matches_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."matches_id_seq"', 226, true);


--
-- Name: partners_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."partners_id_seq"', 1, false);


--
-- Name: referees_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."referees_id_seq"', 4, true);


--
-- Name: round_selection_athletes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."round_selection_athletes_id_seq"', 1, false);


--
-- Name: round_selections_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."round_selections_id_seq"', 1, false);


--
-- Name: solid_queue_batch_executions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."solid_queue_batch_executions_id_seq"', 1, false);


--
-- Name: solid_queue_batches_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."solid_queue_batches_id_seq"', 1, false);


--
-- Name: solid_queue_blocked_executions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."solid_queue_blocked_executions_id_seq"', 1, false);


--
-- Name: solid_queue_claimed_executions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."solid_queue_claimed_executions_id_seq"', 488, true);


--
-- Name: solid_queue_failed_executions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."solid_queue_failed_executions_id_seq"', 7, true);


--
-- Name: solid_queue_jobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."solid_queue_jobs_id_seq"', 488, true);


--
-- Name: solid_queue_pauses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."solid_queue_pauses_id_seq"', 1, false);


--
-- Name: solid_queue_processes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."solid_queue_processes_id_seq"', 282, true);


--
-- Name: solid_queue_ready_executions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."solid_queue_ready_executions_id_seq"', 488, true);


--
-- Name: solid_queue_recurring_executions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."solid_queue_recurring_executions_id_seq"', 475, true);


--
-- Name: solid_queue_recurring_tasks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."solid_queue_recurring_tasks_id_seq"', 138, true);


--
-- Name: solid_queue_scheduled_executions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."solid_queue_scheduled_executions_id_seq"', 1, false);


--
-- Name: solid_queue_semaphores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."solid_queue_semaphores_id_seq"', 1, false);


--
-- Name: standing_rows_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."standing_rows_id_seq"', 57, true);


--
-- Name: suspensions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."suspensions_id_seq"', 1, false);


--
-- Name: team_athletes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."team_athletes_id_seq"', 180, true);


--
-- Name: team_memberships_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."team_memberships_id_seq"', 1, false);


--
-- Name: teams_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."teams_id_seq"', 217, true);


--
-- Name: tranca_classificacao_rows_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."tranca_classificacao_rows_id_seq"', 3080, true);


--
-- Name: tranca_dupla_memberships_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."tranca_dupla_memberships_id_seq"', 171, true);


--
-- Name: tranca_duplas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."tranca_duplas_id_seq"', 161, true);


--
-- Name: tranca_mesas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."tranca_mesas_id_seq"', 199, true);


--
-- Name: tranca_partida_maos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."tranca_partida_maos_id_seq"', 329, true);


--
-- Name: tranca_partidas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."tranca_partidas_id_seq"', 313, true);


--
-- Name: tranca_rodadas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."tranca_rodadas_id_seq"', 23, true);


--
-- Name: tranca_settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."tranca_settings_id_seq"', 1, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."users_id_seq"', 4, true);


--
-- Name: venues_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."venues_id_seq"', 2, true);


--
-- PostgreSQL database dump complete
--

-- \unrestrict nH34CfzDYIyuBRiq6IOWbfF9h5dXx1r4Prc8HvZqMBC36BvZ5KJszOhXqK9Mpwh

RESET ALL;

-- Alterando a tabela para receber os campos novos

ALTER TABLE cryptos_silver
 ADD COLUMN year INT,
 ADD COLUMN month INT, 
 ADD COLUMN day INT,
 ADD COLUMN day_of_week VARCHAR(10);



-- Convertendo o valor de tempo para timestamp

-- convertendo time para milisegundos

 UPDATE cryptos_silver
 	SET time = time / 1000;

-- Adicionando validações nas novas colunas

ALTER TABLE cryptos_silver
	ADD CONSTRAINT valid_year CHECK (year >= 1970),
	ADD CONSTRAINT valid_month CHECK (month BETWEEN 1 AND 12),
	ADD CONSTRAINT valid_day CHECK (day BETWEEN 1 AND 31),
	ADD CONSTRAINT valid_dow CHECK (day_of_week IN ('Sunday','Monday','Tuesday','Wednesday', 'Thursday','Friday','Saturday'));

--  Alterando o tipo da coluna time para timestamp

ALTER TABLE cryptos_silver
 ALTER COLUMN time TYPE TIMESTAMP USING TO_TIMESTAMP(time);

-- Extraindo o valor da coluna time

UPDATE cryptos_silver 
	SET year = EXTRACT(YEAR FROM time), 
		month = EXTRACT(MONTH FROM time),
		day = EXTRACT(DAY FROM time),
		day_of_week = TO_CHAR(time, 'FMDay');

-- Verificando os valores para mudar os tipos das colunas, visando otimização 

SELECT min(time) AS "data mais antiga", max(time) AS "data mais atual", 
	min(open) "menor valor de abertura", max(open) AS "maior valor de abertura",
	min(close) "menor valor de fechamento", max(close) AS "maior valor de fechamento",
	min(high) AS "menor valor de high", max(high) AS "maior valor de high",
	min(low) AS "menor valor de low", max(low) AS "maior valor de low",
	min(volume) AS "menor valor de volume", max(volume) AS "maior valor de volume"	
FROM cryptos_silver;

ALTER TABLE cryptos_silver
	ALTER COLUMN open TYPE NUMERIC(30, 14),
	ALTER COLUMN close TYPE NUMERIC(30,14),
	ALTER COLUMN high TYPE NUMERIC(30,14),
	ALTER COLUMN low TYPE NUMERIC(30,14),
	ALTER COLUMN volume TYPE NUMERIC(30,14);

-- Extraindo os símbolos das moedas;

SELECT DISTINCT(crypto_name)
FROM cryptos_silver;

ALTER TABLE cryptos_silver
 ADD COLUMN crypto_symbol VARCHAR(20);

CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE INDEX ON cryptos_silver USING GIN (crypto_name gin_trgm_ops);


SELECT DISTINCT(crypto_name)
FROM cryptos_silver;

SELECT DISTINCT(crypto_symbol)
FROM cryptos_silver;

UPDATE cryptos_silver
SET crypto_symbol = CASE
    WHEN crypto_name ILIKE '1inch%' THEN '1inch'
    WHEN crypto_name ILIKE 'aave%' THEN 'aave'
    WHEN crypto_name ILIKE 'ada%' THEN 'ada'
    WHEN crypto_name ILIKE 'aix%' THEN 'aix'
    WHEN crypto_name ILIKE 'alb%' THEN 'alb'
    WHEN crypto_name ILIKE 'alg%' THEN 'alg'
    WHEN crypto_name ILIKE 'amp%' THEN 'amp'
    WHEN crypto_name ILIKE 'ant%' THEN 'ant'
    WHEN crypto_name ILIKE 'ape%' THEN 'ape'
    WHEN crypto_name ILIKE 'apt%' THEN 'apt'
    WHEN crypto_name ILIKE 'arb%' THEN 'arb'
    WHEN crypto_name ILIKE 'ast%' THEN 'ast'
    WHEN crypto_name ILIKE 'atlas%' THEN 'atlas'
    WHEN crypto_name ILIKE 'ato%' THEN 'ato'
    WHEN crypto_name ILIKE 'australia%' THEN 'australia'
    WHEN crypto_name ILIKE 'avax%' THEN 'avax'
    WHEN crypto_name ILIKE 'avt%' THEN 'avt'
    WHEN crypto_name ILIKE 'axs%' THEN 'axs'
    WHEN crypto_name ILIKE 'b21x%' THEN 'b21x'
    WHEN crypto_name ILIKE 'b2%' THEN 'b2'
    WHEN crypto_name ILIKE 'bal%' THEN 'bal'
    WHEN crypto_name ILIKE 'band%' THEN 'band'
    WHEN crypto_name ILIKE 'bat%' THEN 'bat'
    WHEN crypto_name ILIKE 'bchabc%' THEN 'bchabc'
    WHEN crypto_name ILIKE 'bchn%' THEN 'bchn'
    WHEN crypto_name ILIKE 'best%' THEN 'best'
    WHEN crypto_name ILIKE 'bft%' THEN 'bft'
    WHEN crypto_name ILIKE 'bgb%' THEN 'bgb'
    WHEN crypto_name ILIKE 'blur%' THEN 'blur'
    WHEN crypto_name ILIKE 'bmi%' THEN 'bmi'
    WHEN crypto_name ILIKE 'bmn%' THEN 'bmn'
    WHEN crypto_name ILIKE 'bnt%' THEN 'bnt'
    WHEN crypto_name ILIKE 'boba%' THEN 'boba'
    WHEN crypto_name ILIKE 'boo%' THEN 'boo'
    WHEN crypto_name ILIKE 'boson%' THEN 'boson'
    WHEN crypto_name ILIKE 'box%' THEN 'box'
    WHEN crypto_name ILIKE 'brise%' THEN 'brise'
    WHEN crypto_name ILIKE 'bsv%' THEN 'bsv'
    WHEN crypto_name ILIKE 'btc%' THEN 'btc'
    WHEN crypto_name ILIKE 'btg%' THEN 'btg'
    WHEN crypto_name ILIKE 'btse%' THEN 'btse'
    WHEN crypto_name ILIKE 'btt%' THEN 'btt'
    WHEN crypto_name ILIKE 'ccd%' THEN 'ccd'
    WHEN crypto_name ILIKE 'cel%' THEN 'cel'
    WHEN crypto_name ILIKE 'chex%' THEN 'chex'
    WHEN crypto_name ILIKE 'chsb%' THEN 'chsb'
    WHEN crypto_name ILIKE 'chz%' THEN 'chz'
    WHEN crypto_name ILIKE 'clo%' THEN 'clo'
    WHEN crypto_name ILIKE 'cnd%' THEN 'cnd'
    WHEN crypto_name ILIKE 'cnh%' THEN 'cnh'
    WHEN crypto_name ILIKE 'comp%' THEN 'comp'
    WHEN crypto_name ILIKE 'conv%' THEN 'conv'
    WHEN crypto_name ILIKE 'crf%' THEN 'crf'
    WHEN crypto_name ILIKE 'ctk%' THEN 'ctk'
    WHEN crypto_name ILIKE 'ctx%' THEN 'ctx'
    WHEN crypto_name ILIKE 'dai%' THEN 'dai'
    WHEN crypto_name ILIKE 'dapp%' THEN 'dapp'
    WHEN crypto_name ILIKE 'dat%' THEN 'dat'
    WHEN crypto_name ILIKE 'dcr%' THEN 'dcr'
    WHEN crypto_name ILIKE 'dgb%' THEN 'dgb'
    WHEN crypto_name ILIKE 'dgx%' THEN 'dgx'
    WHEN crypto_name ILIKE 'dog%' THEN 'dog'
    WHEN crypto_name ILIKE 'doge%' THEN 'doge'
    WHEN crypto_name ILIKE 'dora%' THEN 'dora'
    WHEN crypto_name ILIKE 'dot%' THEN 'dot'
    WHEN crypto_name ILIKE 'drn%' THEN 'drn'
    WHEN crypto_name ILIKE 'dsh%' THEN 'dsh'
    WHEN crypto_name ILIKE 'dta%' THEN 'dta'
    WHEN crypto_name ILIKE 'dtx%' THEN 'dtx'
    WHEN crypto_name ILIKE 'dusk%' THEN 'dusk'
    WHEN crypto_name ILIKE 'dvf%' THEN 'dvf'
    ELSE '-'
END
WHERE crypto_name ILIKE ANY (ARRAY[
    '1inch%', 'aave%', 'ada%', 'aix%', 'alb%', 'alg%', 'amp%', 'ant%', 'ape%', 
    'apt%', 'arb%', 'ast%', 'atlas%', 'ato%', 'australia%', 'avax%', 'avt%', 'axs%', 
    'b21x%', 'b2%', 'bal%', 'band%', 'bat%', 'bchabc%', 'bchn%', 'best%', 'bft%', 
    'bgb%', 'blur%', 'bmi%', 'bmn%', 'bnt%', 'boba%', 'boo%', 'boson%', 'box%', 
    'brise%', 'bsv%', 'btc%', 'btg%', 'btse%', 'btt%', 'ccd%', 'cel%', 'chex%', 
    'chsb%', 'chz%', 'clo%', 'cnd%', 'cnh%', 'comp%', 'conv%', 'crf%', 'ctk%', 
    'ctx%', 'dai%', 'dapp%', 'dat%', 'dcr%', 'dgb%', 'dgx%', 'dog%', 'doge%', 
    'dora%', 'dot%', 'drn%', 'dsh%', 'dta%', 'dtx%', 'dusk%', 'dvf%'
]);


UPDATE cryptos_silver
SET crypto_symbol = CASE
    WHEN crypto_name ILIKE 'edo%' THEN 'edo'
    WHEN crypto_name ILIKE 'egld%' THEN 'egld'
    WHEN crypto_name ILIKE 'eos%' THEN 'eos'
    WHEN crypto_name ILIKE 'ess%' THEN 'ess'
    WHEN crypto_name ILIKE 'etc%' THEN 'etc'
    WHEN crypto_name ILIKE 'eth2x%' THEN 'eth2x'
    WHEN crypto_name ILIKE 'eth%' THEN 'eth'
    WHEN crypto_name ILIKE 'etp%' THEN 'etp'
    WHEN crypto_name ILIKE 'eur%' THEN 'eur' 
    WHEN crypto_name ILIKE 'eus%' THEN 'eus'
    WHEN crypto_name ILIKE 'eut%' THEN 'eut'
    WHEN crypto_name ILIKE 'exrd%' THEN 'exrd'
    WHEN crypto_name ILIKE 'fbt%' THEN 'fbt'
    WHEN crypto_name ILIKE 'fcl%' THEN 'fcl'
    WHEN crypto_name ILIKE 'fet%' THEN 'fet'
    WHEN crypto_name ILIKE 'fil%' THEN 'fil'
    WHEN crypto_name ILIKE 'floki%' THEN 'floki'
    WHEN crypto_name ILIKE 'flr%' THEN 'flr'
    WHEN crypto_name ILIKE 'forth%' THEN 'forth'
    WHEN crypto_name ILIKE 'france%' THEN 'france'
    WHEN crypto_name ILIKE 'ftm%' THEN 'ftm'
    WHEN crypto_name ILIKE 'ftt%' THEN 'ftt'
    WHEN crypto_name ILIKE 'fun%' THEN 'fun'
    WHEN crypto_name ILIKE 'gala%' THEN 'gala'
    WHEN crypto_name ILIKE 'gbp%' THEN 'gbp'
    WHEN crypto_name ILIKE 'gen%' THEN 'gen'
    WHEN crypto_name ILIKE 'germany30ixf0%' THEN 'germany30ixf0'
    WHEN crypto_name ILIKE 'germany40ixf0%' THEN 'germany40ixf0'
    WHEN crypto_name ILIKE 'gmt%' THEN 'gmt'
    WHEN crypto_name ILIKE 'gno%' THEN 'gno'
    WHEN crypto_name ILIKE 'gnt%' THEN 'gnt'
    WHEN crypto_name ILIKE 'goc%' THEN 'goc'
    WHEN crypto_name ILIKE 'got%' THEN 'got'
    WHEN crypto_name ILIKE 'gpt%' THEN 'gpt'
    WHEN crypto_name ILIKE 'grt%' THEN 'grt'
    WHEN crypto_name ILIKE 'gst%' THEN 'gst'
    WHEN crypto_name ILIKE 'gtx%' THEN 'gtx'
    WHEN crypto_name ILIKE 'gxt%' THEN 'gxt'
    ELSE crypto_symbol  
END
WHERE crypto_name ILIKE ANY (ARRAY[
    'edo%', 'egld%', 'eos%', 'ess%', 'etc%', 'eth2x%', 'eth%', 'etp%', 
    'eur%', 'europe%', 'eus%', 'eut%', 'exrd%', 'fbt%', 'fcl%', 'fet%', 
    'fil%', 'floki%', 'flr%', 'forth%', 'france%', 'ftm%', 'ftt%', 'fun%', 
    'gala%', 'gbp%', 'gen%', 'germany30ixf0%', 'germany40ixf0%', 'gmt%', 
    'gno%', 'gnt%', 'goc%', 'got%', 'gpt%', 'grt%', 'gst%', 'gtx%', 'gxt%'
]);


	
UPDATE cryptos_silver
SET crypto_symbol = CASE
    WHEN crypto_name ILIKE 'hec%' THEN 'hec'
    WHEN crypto_name ILIKE 'hez%' THEN 'hez'
    WHEN crypto_name ILIKE 'hix%' THEN 'hix'
    WHEN crypto_name ILIKE 'hmt%' THEN 'hmt'
    WHEN crypto_name ILIKE 'hongkong%' THEN 'hongkong'
    WHEN crypto_name ILIKE 'hot%' THEN 'hot'
    WHEN crypto_name ILIKE 'htx%' THEN 'htx'
    WHEN crypto_name ILIKE 'ice%' THEN 'ice'
    WHEN crypto_name ILIKE 'icp%' THEN 'icp'
    WHEN crypto_name ILIKE 'idx%' THEN 'idx'
    WHEN crypto_name ILIKE 'ios%' THEN 'ios'
    WHEN crypto_name ILIKE 'iot%' THEN 'iot'
    WHEN crypto_name ILIKE 'iqx%' THEN 'iqx'
    WHEN crypto_name ILIKE 'japan%' THEN 'japan'
    WHEN crypto_name ILIKE 'jasmy%' THEN 'jasmy'
    WHEN crypto_name ILIKE 'jpy%' THEN 'jpy'
    WHEN crypto_name ILIKE 'jst%' THEN 'jst'
    WHEN crypto_name ILIKE 'kai%' THEN 'kai'
    WHEN crypto_name ILIKE 'kan%' THEN 'kan'
    WHEN crypto_name ILIKE 'karate%' THEN 'karate'
    WHEN crypto_name ILIKE 'knc%' THEN 'knc'
    WHEN crypto_name ILIKE 'ksm%' THEN 'ksm'
    WHEN crypto_name ILIKE 'lai%' THEN 'lai'
    WHEN crypto_name ILIKE 'ldo%' THEN 'ldo'
    WHEN crypto_name ILIKE 'leo%' THEN 'leo'
    WHEN crypto_name ILIKE 'link%' THEN 'link'
    WHEN crypto_name ILIKE 'lrc%' THEN 'lrc'
    WHEN crypto_name ILIKE 'ltc%' THEN 'ltc'
    WHEN crypto_name ILIKE 'luna2%' THEN 'luna2'
    WHEN crypto_name ILIKE 'luna%' THEN 'luna'
    WHEN crypto_name ILIKE 'luxo%' THEN 'luxo'
    WHEN crypto_name ILIKE 'lym%' THEN 'lym'
    WHEN crypto_name ILIKE 'man%' THEN 'man'
    WHEN crypto_name ILIKE 'matic%' THEN 'matic'
    WHEN crypto_name ILIKE 'mgo%' THEN 'mgo'
    WHEN crypto_name ILIKE 'mim%' THEN 'mim'
    WHEN crypto_name ILIKE 'mir%' THEN 'mir'
    WHEN crypto_name ILIKE 'mkr%' THEN 'mkr'
    WHEN crypto_name ILIKE 'mln%' THEN 'mln'
    WHEN crypto_name ILIKE 'mna%' THEN 'mna'
    WHEN crypto_name ILIKE 'mob%' THEN 'mob'
    WHEN crypto_name ILIKE 'mtn%' THEN 'mtn'
    WHEN crypto_name ILIKE 'mxnt%' THEN 'mxnt'
    WHEN crypto_name ILIKE 'nca%' THEN 'nca'
    WHEN crypto_name ILIKE 'near%' THEN 'near'
    WHEN crypto_name ILIKE 'nec%' THEN 'nec'
    WHEN crypto_name ILIKE 'neo%' THEN 'neo'
    WHEN crypto_name ILIKE 'nexo%' THEN 'nexo'
    WHEN crypto_name ILIKE 'nom%' THEN 'nom'
    WHEN crypto_name ILIKE 'nut%' THEN 'nut'
    WHEN crypto_name ILIKE 'nxra%' THEN 'nxra'
    WHEN crypto_name ILIKE 'ocean%' THEN 'ocean'
    WHEN crypto_name ILIKE 'ode%' THEN 'ode'
    WHEN crypto_name ILIKE 'ogn%' THEN 'ogn'
    WHEN crypto_name ILIKE 'okb%' THEN 'okb'
    WHEN crypto_name ILIKE 'omg%' THEN 'omg'
    WHEN crypto_name ILIKE 'omn%' THEN 'omn'
    WHEN crypto_name ILIKE 'one%' THEN 'one'
    WHEN crypto_name ILIKE 'onl%' THEN 'onl'
    WHEN crypto_name ILIKE 'opx%' THEN 'opx'
    WHEN crypto_name ILIKE 'ors%' THEN 'ors'
    WHEN crypto_name ILIKE 'oxy%' THEN 'oxy'
    WHEN crypto_name ILIKE 'pas%' THEN 'pas'
    WHEN crypto_name ILIKE 'pax%' THEN 'pax'
    WHEN crypto_name ILIKE 'pepe%' THEN 'pepe'
    WHEN crypto_name ILIKE 'planets%' THEN 'planets'
    WHEN crypto_name ILIKE 'plu%' THEN 'plu'
    WHEN crypto_name ILIKE 'png%' THEN 'png'
    WHEN crypto_name ILIKE 'pnk%' THEN 'pnk'
    WHEN crypto_name ILIKE 'poa%' THEN 'poa'
    WHEN crypto_name ILIKE 'polc%' THEN 'polc'
    WHEN crypto_name ILIKE 'polis%' THEN 'polis'
    WHEN crypto_name ILIKE 'prmx%' THEN 'prmx'
    WHEN crypto_name ILIKE 'qrdo%' THEN 'qrdo'
    WHEN crypto_name ILIKE 'qsh%' THEN 'qsh'
    WHEN crypto_name ILIKE 'qtf%' THEN 'qtf'
    WHEN crypto_name ILIKE 'qtm%' THEN 'qtm'
    WHEN crypto_name ILIKE 'rbt%' THEN 'rbt'
    WHEN crypto_name ILIKE 'rcn%' THEN 'rcn'
    WHEN crypto_name ILIKE 'reef%' THEN 'reef'
    WHEN crypto_name ILIKE 'rep%' THEN 'rep'
    WHEN crypto_name ILIKE 'rif%' THEN 'rif'
    WHEN crypto_name ILIKE 'ringx%' THEN 'ringx'
    WHEN crypto_name ILIKE 'rly%' THEN 'rly'
    WHEN crypto_name ILIKE 'rrb%' THEN 'rrb'
    WHEN crypto_name ILIKE 'rrt%' THEN 'rrt'
    ELSE crypto_symbol 
END
WHERE crypto_name ILIKE ANY (ARRAY[
    'hec%', 'hez%', 'hix%', 'hmt%', 'hongkong%', 'hot%', 'htx%', 'ice%', 
    'icp%', 'idx%', 'ios%', 'iot%', 'iqx%', 'japan%', 'jasmy%', 'jpy%', 
    'jst%', 'kai%', 'kan%', 'karate%', 'knc%', 'ksm%', 'lai%', 'ldo%', 
    'leo%', 'link%', 'lrc%', 'ltc%', 'luna2%', 'luna%', 'luxo%', 'lym%', 
    'man%', 'matic%', 'mgo%', 'mim%', 'mir%', 'mkr%', 'mln%', 'mna%', 
    'mob%', 'mtn%', 'mxnt%', 'nca%', 'near%', 'nec%', 'neo%', 'nexo%', 
    'nom%', 'nut%', 'nxra%', 'ocean%', 'ode%', 'ogn%', 'okb%', 'omg%', 
    'omn%', 'one%', 'onl%', 'opx%', 'ors%', 'oxy%', 'pas%', 'pax%', 'pepe%', 
    'planets%', 'plu%', 'png%', 'pnk%', 'poa%', 'polc%', 'polis%', 'prmx%', 
    'qrdo%', 'qsh%', 'qtf%', 'qtm%', 'rbt%', 'rcn%', 'reef%', 'rep%', 
    'rif%', 'ringx%', 'rly%', 'rrb%', 'rrt%'
]);

UPDATE cryptos_silver
SET crypto_symbol = CASE
    WHEN crypto_name ILIKE 'san%' THEN 'san'
    WHEN crypto_name ILIKE 'sand%' THEN 'sand'
    WHEN crypto_name ILIKE 'sei%' THEN 'sei'
    WHEN crypto_name ILIKE 'senate%' THEN 'senate'
    WHEN crypto_name ILIKE 'sgb%' THEN 'sgb'
    WHEN crypto_name ILIKE 'shft%' THEN 'shft'
    WHEN crypto_name ILIKE 'shib%' THEN 'shib'
    WHEN crypto_name ILIKE 'sidus%' THEN 'sidus'
    WHEN crypto_name ILIKE 'smr%' THEN 'smr'
    WHEN crypto_name ILIKE 'sng%' THEN 'sng'
    WHEN crypto_name ILIKE 'snt%' THEN 'snt'
    WHEN crypto_name ILIKE 'snx%' THEN 'snx'
    WHEN crypto_name ILIKE 'sol%' THEN 'sol'
    WHEN crypto_name ILIKE 'spain%' THEN 'spain'
    WHEN crypto_name ILIKE 'spell%' THEN 'spell'
    WHEN crypto_name ILIKE 'srm%' THEN 'srm'
    WHEN crypto_name ILIKE 'stg%' THEN 'stg'
    WHEN crypto_name ILIKE 'stj%' THEN 'stj'
    WHEN crypto_name ILIKE 'sui%' THEN 'sui'
    WHEN crypto_name ILIKE 'suku%' THEN 'suku'
    WHEN crypto_name ILIKE 'sun%' THEN 'sun'
    WHEN crypto_name ILIKE 'sushi%' THEN 'sushi'
    WHEN crypto_name ILIKE 'sweat%' THEN 'sweat'
    WHEN crypto_name ILIKE 'swm%' THEN 'swm'
    WHEN crypto_name ILIKE 'sxx%' THEN 'sxx'
    WHEN crypto_name ILIKE 'tenet%' THEN 'tenet'
    WHEN crypto_name ILIKE 'terraust%' THEN 'terraust'
    WHEN crypto_name ILIKE 'test%' THEN 'test'
    WHEN crypto_name ILIKE 'theta%' THEN 'theta'
    WHEN crypto_name ILIKE 'tkn%' THEN 'tkn'
    WHEN crypto_name ILIKE 'tlos%' THEN 'tlos'
    WHEN crypto_name ILIKE 'ton%' THEN 'ton'
    WHEN crypto_name ILIKE 'trade%' THEN 'trade'
    WHEN crypto_name ILIKE 'treeb%' THEN 'treeb'
    WHEN crypto_name ILIKE 'tri%' THEN 'tri'
    WHEN crypto_name ILIKE 'trx%' THEN 'trx'
    WHEN crypto_name ILIKE 'try%' THEN 'try'
    WHEN crypto_name ILIKE 'udc%' THEN 'udc'
    WHEN crypto_name ILIKE 'uk100%' THEN 'uk100'
    WHEN crypto_name ILIKE 'ukoil%' THEN 'ukoil'
    WHEN crypto_name ILIKE 'unif%' THEN 'unif'
    WHEN crypto_name ILIKE 'uni%' THEN 'uni'
    WHEN crypto_name ILIKE 'uop%' THEN 'uop'
    WHEN crypto_name ILIKE 'uos%' THEN 'uos'
    WHEN crypto_name ILIKE 'usk%' THEN 'usk'
    WHEN crypto_name ILIKE 'ust%' THEN 'ust'
    WHEN crypto_name ILIKE 'utk%' THEN 'utk'
    WHEN crypto_name ILIKE 'vee%' THEN 'vee'
    WHEN crypto_name ILIKE 'velo%' THEN 'velo'
    WHEN crypto_name ILIKE 'vet%' THEN 'vet'
    WHEN crypto_name ILIKE 'vra%' THEN 'vra'
    WHEN crypto_name ILIKE 'vsy%' THEN 'vsy'
    WHEN crypto_name ILIKE 'waves%' THEN 'waves'
    WHEN crypto_name ILIKE 'wax%' THEN 'wax'
    WHEN crypto_name ILIKE 'wbt%' THEN 'wbt'
    WHEN crypto_name ILIKE 'whbt%' THEN 'whbt'
    WHEN crypto_name ILIKE 'wild%' THEN 'wild'
    WHEN crypto_name ILIKE 'wminima%' THEN 'wminima'
    WHEN crypto_name ILIKE 'wncg%' THEN 'wncg'
    WHEN crypto_name ILIKE 'woo%' THEN 'woo'
    WHEN crypto_name ILIKE 'wpr%' THEN 'wpr'
    WHEN crypto_name ILIKE 'wtc%' THEN 'wtc'
    WHEN crypto_name ILIKE 'xag%' THEN 'xag'
    WHEN crypto_name ILIKE 'xaut%' THEN 'xaut'
    WHEN crypto_name ILIKE 'xcad%' THEN 'xcad'
    WHEN crypto_name ILIKE 'xch%' THEN 'xch'
    WHEN crypto_name ILIKE 'xcn%' THEN 'xcn'
    WHEN crypto_name ILIKE 'xdc%' THEN 'xdc'
    WHEN crypto_name ILIKE 'xlm%' THEN 'xlm'
    WHEN crypto_name ILIKE 'xmr%' THEN 'xmr'
    WHEN crypto_name ILIKE 'xpd%' THEN 'xpd'
    WHEN crypto_name ILIKE 'xpt%' THEN 'xpt'
    WHEN crypto_name ILIKE 'xra%' THEN 'xra'
    WHEN crypto_name ILIKE 'xrd%' THEN 'xrd'
    WHEN crypto_name ILIKE 'xrp%' THEN 'xrp'
    WHEN crypto_name ILIKE 'xsn%' THEN 'xsn'
    WHEN crypto_name ILIKE 'xtz%' THEN 'xtz'
    WHEN crypto_name ILIKE 'xvg%' THEN 'xvg'
    WHEN crypto_name ILIKE 'yfi%' THEN 'yfi'
    WHEN crypto_name ILIKE 'ygg%' THEN 'ygg'
    WHEN crypto_name ILIKE 'zbt%' THEN 'zbt'
    WHEN crypto_name ILIKE 'zcn%' THEN 'zcn'
    WHEN crypto_name ILIKE 'zec%' THEN 'zec'
    WHEN crypto_name ILIKE 'zil%' THEN 'zil'
    WHEN crypto_name ILIKE 'zmt%' THEN 'zmt'
    WHEN crypto_name ILIKE 'zrx%' THEN 'zrx'
    ELSE '-'
END
WHERE crypto_name ILIKE ANY (ARRAY[
    'san%', 'sand%', 'sei%', 'senate%', 'sgb%', 'shft%', 'shib%', 'sidus%', 
    'smr%', 'sng%', 'snt%', 'snx%', 'sol%', 'spain%', 'spell%', 'srm%', 
    'stg%', 'stj%', 'sui%', 'suku%', 'sun%', 'sushi%', 'sweat%', 'swm%', 
    'sxx%', 'tenet%', 'terraust%', 'test%', 'theta%', 'tkn%', 'tlos%', 'ton%', 
    'trade%', 'treeb%', 'tri%', 'trx%', 'try%', 'udc%', 'uk100%', 'ukoil%', 
    'unif%', 'uni%', 'uop%', 'uos%', 'usk%', 'ust%', 'utk%', 'vee%', 'velo%', 
    'vet%', 'vra%', 'vsy%', 'waves%', 'wax%', 'wbt%', 'whbt%', 'wild%', 
    'wminima%', 'wncg%', 'woo%', 'wpr%', 'wtc%', 'xag%', 'xaut%', 'xcad%', 
    'xch%', 'xcn%', 'xdc%', 'xlm%', 'xmr%', 'xpd%', 'xpt%', 'xra%', 'xrd%', 
    'xrp%', 'xsn%', 'xtz%', 'xvg%', 'yfi%', 'ygg%', 'zbt%', 'zcn%', 'zec%', 
    'zil%', 'zmt%', 'zrx%'
]);

UPDATE cryptos_silver
SET crypto_symbol = CASE
    WHEN crypto_name ILIKE 'anc%' THEN 'anc'
    WHEN crypto_name ILIKE 'crv%' THEN 'crv'
    WHEN crypto_name ILIKE 'enj%' THEN 'enj'
    WHEN crypto_name ILIKE 'req%' THEN 'req'
    WHEN crypto_name ILIKE 'tsd%' THEN 'tsd'
    WHEN crypto_name ILIKE 'yyw%' THEN 'yyw'
    ELSE crypto_symbol
END
WHERE crypto_name ILIKE ANY (ARRAY[
    'anc%', 'crv%', 'enj%', 'req%', 'tsd%', 'yyw%' 
]);	
	
-- Adicionando a coluna horas, inicialmente tinha
-- escolhido não ter isso mas mudei de ideia
-- já que é um dados que pode gerar mais 
-- informações

ALTER TABLE cryptos_silver
 ADD COLUMN hour INT;

ALTER TABLE cryptos_silver
	ADD CONSTRAINT valid_hour CHECK (hour BETWEEN 0 AND 24); 

UPDATE cryptos_silver 
	SET hour = EXTRACT(HOUR FROM time);

	
	
	

 
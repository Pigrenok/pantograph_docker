# Pantograph graph processing and visualisation docker infrastructure

This Docker Compose infrastructure allows a user to easily deploy [Pantograph Visualisation tool](https://github.com/Pigrenok/pantograph_visual) (including the React App as well as DB with metadata and related API to access this DB). It also contains an on-demand service to use `pantograph` command line tool (and underlying [pyGenGraph](https://github.com/Pigrenok/pygengraph) python package) which can process genome graphs and export them to visualisation tool.

## Running Pantograph Visualisation tool with Redis DB and DB API.

This repo present an easy way to deploy both Pantograph graph visualisation tool (with its metadata DB and API interface) as well as pyGenGraph python package
for genome graphs construction, processing and exporting to Pantograph Visualisation tool.

In order to run Pantograph, all you need to do is

```bash
git clone ...

cd pantograph_docker
```

Then open `docker-compose.yaml` in your favourite text editor and set up your paths as you would prefer (see comments in docker compose file).

After that just in the main directory where the repo was cloned, just do

```bash
docker compose up -d
```

That is it. Now just head to `http://localhost:8888` and the app is there. 
By default there is no data coming with this repo. There are a couple of examples available in the [Pantograph Visual repo](https://github.com/Pigrenok/pantograph_visual/tree/master/public/data), which you can download, put it into `./data/visdata` directory in this repo and try it on. Alternatively, run the examples for Pantograph processing tool below and it will create the same examples.

Also, it is set up to use with unsecured HTTP web-server. If you would like to set up sequred SSL server, uncomment marked (with comments) lines in 
`docker-compose.yaml` and read comments at the bottom of the file.

You will need to rerun certbot regularly to renew your certificates or set in on cron.

## Processing graphs using pyGenGraph command line tool `pantograph`

Now, if you would like to generate your own graph or export existing graph you can use extra image for pyGenGraph package with available command line interface.

In order to run it, just do

```bash
docker compose run pantograph --help
```

To get what this command line interface has to offer. Details are available in pyGenGraph repo. `pantograph` container will not run automatically with `docker compose up` and it needs to be run manually with specific parameters. The following examples gives the idea how to use it:

Please note, by deafult the tool in docker runs under root user (UID 0, GID 0). All files created using the processing tool on mounted volumes will be created with root ownership, but will have read/write permission for all. If you want all your files to be created with ownership of your user on your host system, you need to set an environment variable `UID_GID` to have `<your user ID>:<your group ID>`, e.g. `1000:1000`. To set it to your current user and group, just run the following command in terminal

```bash
export UID_GID=$(id -u):$(id -g)
```

or add it to your `.bashrc` (for bash shell) to have it always set in any terminal session.

## Examples

### Converting paths to graph

```bash
docker compose run pantograph paths2graph -g /examples/gene_graph/settings.yaml
```

Then set the following parameters in YAML file

```yaml
pathfileDir: /examples/gene_graph
pathFiles:
    Main: paths_genegraph.txt
# pathFile: paths_graph.txt # This line needs to be commented in the sample file!
outputpath: /examples/gene_graph
outputBasename: 'path_genegraph'
```

and then just run

```bash
docker compose run pantograph paths2graph /examples/gene_graph/settings.yaml
```
This should create a graph with extra files in the same directory.

### Converting annotations to graph

In similar way as converting paths to graph, annotations can also be converted to graphs. The requirement is that annotations for various accessions will have some sort of similarity IDs for genes (e.g. if two genes are similar/the same, each gene record should have specific field in GFF file which have the same identificator, at the moment fields OG is searched for, but this can be changed).

In terms of how to use command line tool, it is the same way as for converting paths to graph. You first generate sample setting YAML file and then edit it to fit your case. THe sample YAML file has very extensive description of each parameter.

In order to understand how a graph is formed from annotations, read about Gene Graphs in the user manual.

### Sorting graph

If you already have a graph which you need to sort (make an order of the nodes for visualising it in linearised manner), then you can do the following command in the main repo directory:

```bash
docker compose run pantograph sort-graph --isseq --output /examples/nucleotide_graph/paths_presentation_sorted.gfa /examples/nucleotide_graph/paths_presentation.gfa
```

Do not forget that that it will run Redis server automatically if it is not already running.

### Exporting graph to Pantograph visualisation tool.

In order to export a graph to visualisation tool (running in docker already if you did `docker compose up` before), first you need to generate a sample setting file. Two examples, one for gene graph, and one for nucleotide graph are provided:

#### Exporting gene graph

Generate sample setting file:

```bash
docker compose run pantograph export-vis -g /examples/gene_graph/settings_export.yaml
```

Then change generated file `settings_export.yaml`, which should contain the following uncommented lines:

```yaml
projectID: paths_genegraph
projectName: Sample gene graph
caseDict:
    Main: path_genegraph_Main.gfa
pathToIndex: /data
pathToGraphs: /examples/gene_graph
redisHost: redis
isSeq: False
zoomLevels: [1,2,4]
```

After that you only need to run

```bash
docker compose run pantograph export-vis /examples/gene_graph/settings_export.yaml
```

and that is it.

#### Exporting nucleotide graph

The same principles as before. First, Generate sample setting file:

```bash
docker compose run pantograph export-vis -g /examples/nucleotide_graph/settings_export.yaml
```

Then change generated file `settings_export.yaml`, which should contain the following uncommented lines:

```yaml
projectID: nucleotide_graph
projectName: "Sample nucleotide graph"
caseDict:
    Main: paths_presentation_sorted.gfa
pathToIndex: /data
pathToGraphs: /examples/nucleotide_graph
redisHost: 'redis'
zoomLevels: [1,2,4]
```

After that you only need to run

```bash
docker compose run pantograph export-vis /examples/nucleotide_graph/settings_export.yaml
```

and that is it.

### Seeing exported graphs

If you did not started the main docker infrastructure, do

```bash
docker compose up -d
```

Just open your browser and go to `http://localhost:8888` and you should see the following


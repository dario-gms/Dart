# Apostila Dart 2.0

## 1. Introdução ao Dart e Ecossistema

### 1.1 História e Contexto Tecnológico

Dart foi criado pelo Google em 2011 como resposta às limitações do JavaScript. Inicialmente projetado para substituir o JavaScript no navegador, evoluiu para se tornar a linguagem do Flutter e uma opção robusta para backend.

```dart
// Exemplo histórico: Dart 1.0 vs Dart 2.0+
// Dart 1.0 (opcional types)
var name = 'João';
var age; // poderia ser qualquer tipo

// Dart 2.0+ (sound null safety)
String name = 'João';
int? age; // explicitamente nullable
```

### 1.2 Paradigmas Suportados

Dart é uma linguagem multi-paradigma que suporta:

```dart
// Programação Imperativa
void exemploImperativo() {
  var contador = 0;
  for (int i = 0; i < 10; i++) {
    contador += i;
  }
  print(contador);
}

// Programação Orientada a Objetos
class Pessoa {
  String nome;
  int idade;
  
  Pessoa(this.nome, this.idade);
  
  void apresentar() => print('Olá, sou $nome');
}

// Programação Funcional
void exemploFuncional() {
  var numeros = [1, 2, 3, 4, 5];
  var pares = numeros
    .where((n) => n % 2 == 0)
    .map((n) => n * 2)
    .toList();
  print(pares); // [4, 8]
}
```

### 1.3 Compilação e Targets

```dart
// Exemplo de código que funciona em múltiplas plataformas
import 'dart:io' if (dart.library.html) 'dart:html';

void exemploMultiplataforma() {
  // Este código compila para:
  // - Native (Mobile/Desktop): usa dart:io
  // - Web: usa dart:html
  print('Executando em ${Platform.operatingSystem}');
}
```

## 2. Sistema de Tipos Avançado

### 2.1 Null Safety em Profundidade

```dart
// Tipos não-anuláveis (default)
String nome = 'João'; // nunca pode ser null

// Tipos anuláveis (explícito)
String? sobrenome; // pode ser null

// Operadores null-aware
String nomeCompleto = nome + (sobrenome ?? 'Silva');
int? tamanho = sobrenome?.length; // null se sobrenome for null

// Assertion operator (!)
String garantido = sobrenome!; // RuntimeError se null

// Null-aware cascade
class Builder {
  String? _nome;
  int? _idade;
  
  Builder setNome(String nome) {
    _nome = nome;
    return this;
  }
  
  Builder setIdade(int idade) {
    _idade = idade;
    return this;
  }
}

// Uso com null-aware
Builder? builder;
builder?..setNome('João')..setIdade(30);
```

### 2.2 Generics Avançados

```dart
// Bounded Type Parameters
class Repository<T extends Identifiable> {
  List<T> _items = [];
  
  T? findById(String id) {
    return _items.firstWhere(
      (item) => item.id == id,
      orElse: () => null,
    );
  }
}

abstract class Identifiable {
  String get id;
}

class Usuario implements Identifiable {
  @override
  final String id;
  final String nome;
  
  Usuario(this.id, this.nome);
}

// Covariance e Contravariance
class Animal {}
class Gato extends Animal {}

// Covariant (out)
List<Gato> gatos = <Gato>[];
List<Animal> animais = gatos; // OK - covariant

// Function types contravariance
typedef Callback<T> = void Function(T item);
Callback<Animal> callbackAnimal = (animal) => print(animal);
Callback<Gato> callbackGato = callbackAnimal; // OK - contravariant
```

### 2.3 Type Inference Sofisticada

```dart
// Inference em coleções complexas
var mapa = <String, List<int>>{
  'pares': [2, 4, 6],
  'ímpares': [1, 3, 5],
}; // Map<String, List<int>> inferido

// Inference em closures
var processador = <T>(T item, T Function(T) transform) {
  return transform(item);
};

var resultado = processador('hello', (s) => s.toUpperCase());
// String inferido para T
```

## 3. Metaprogramação e Reflection

### 3.1 Annotations Customizadas

```dart
// Definindo annotations
class ApiEndpoint {
  final String path;
  final String method;
  
  const ApiEndpoint(this.path, {this.method = 'GET'});
}

class Deprecated {
  final String reason;
  const Deprecated(this.reason);
}

// Usando annotations
class UserController {
  @ApiEndpoint('/users', method: 'POST')
  void createUser() {}
  
  @Deprecated('Use getUserById instead')
  @ApiEndpoint('/user')
  void getUser() {}
}
```

### 3.2 Extensions Avançadas

```dart
// Extension básica
extension StringExtensions on String {
  bool get isEmail => contains('@') && contains('.');
  
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}

// Extension com generics
extension IterableExtensions<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
  
  Map<K, List<T>> groupBy<K>(K Function(T) keySelector) {
    var groups = <K, List<T>>{};
    for (var element in this) {
      var key = keySelector(element);
      groups.putIfAbsent(key, () => []).add(element);
    }
    return groups;
  }
}

// Extension em tipos nullable
extension NullableStringExtensions on String? {
  bool get isNullOrEmpty => this?.isEmpty ?? true;
  
  String get orEmpty => this ?? '';
}

// Uso das extensions
void exemploExtensions() {
  print('DART'.capitalize()); // Dart
  print('user@example.com'.isEmail); // true
  
  var numeros = [1, 2, 3, 4, 5];
  print(numeros.firstOrNull); // 1
  
  var pessoas = ['Ana', 'Bruno', 'Carlos'];
  var grupos = pessoas.groupBy((nome) => nome[0]);
  print(grupos); // {A: [Ana], B: [Bruno], C: [Carlos]}
  
  String? nome;
  print(nome.isNullOrEmpty); // true
}
```

### 3.3 Mixins Avançados e On Clause

```dart
// Mixin com 'on' constraint
mixin Flyable on Animal {
  double altitude = 0.0;
  
  void fly() {
    altitude += 100;
    print('$nome voando a ${altitude}m');
  }
  
  void land() {
    altitude = 0;
    print('$nome pousou');
  }
}

mixin Swimmable on Animal {
  double depth = 0.0;
  
  void swim() {
    depth += 10;
    print('$nome nadando a ${depth}m de profundidade');
  }
}

class Animal {
  String nome;
  Animal(this.nome);
}

class Pato extends Animal with Flyable, Swimmable {
  Pato(String nome) : super(nome);
}

// Mixin com abstract members
mixin Loggable {
  String get loggerName;
  
  void log(String message) {
    print('[$loggerName] $message');
  }
}

class DatabaseService with Loggable {
  @override
  String get loggerName => 'DatabaseService';
  
  void connect() {
    log('Conectando ao banco de dados...');
  }
}
```

## 4. Programação Assíncrona Avançada

### 4.1 Futures Complexos

```dart
import 'dart:math';

// Future com timeout e retry
Future<String> fetchDataWithRetry({
  int maxRetries = 3,
  Duration timeout = const Duration(seconds: 5),
}) async {
  for (int attempt = 1; attempt <= maxRetries; attempt++) {
    try {
      return await fetchData().timeout(timeout);
    } catch (e) {
      if (attempt == maxRetries) rethrow;
      await Future.delayed(Duration(seconds: attempt));
    }
  }
  throw StateError('Não deveria chegar aqui');
}

Future<String> fetchData() async {
  // Simula falha aleatória
  await Future.delayed(Duration(milliseconds: 100));
  if (Random().nextBool()) {
    throw Exception('Falha na rede');
  }
  return 'Dados obtidos com sucesso';
}

// Combinando múltiplos futures
Future<void> exemploFutureCombinations() async {
  // Parallel execution
  var futures = [
    fetchUser('1'),
    fetchUser('2'),
    fetchUser('3'),
  ];
  
  // Wait all
  try {
    var users = await Future.wait(futures);
    print('Todos os usuários: $users');
  } catch (e) {
    print('Erro ao buscar usuários: $e');
  }
  
  // First to complete
  var firstUser = await Future.any(futures);
  print('Primeiro usuário: $firstUser');
  
  // Timeout global
  try {
    var result = await Future.wait(futures)
        .timeout(Duration(seconds: 2));
    print('Resultado: $result');
  } on TimeoutException {
    print('Timeout!');
  }
}

Future<String> fetchUser(String id) async {
  await Future.delayed(Duration(milliseconds: Random().nextInt(1000)));
  return 'Usuario_$id';
}
```

### 4.2 Streams Avançados

```dart
import 'dart:async';

// Stream Controller customizado
class EventBus<T> {
  final StreamController<T> _controller = StreamController<T>.broadcast();
  
  Stream<T> get stream => _controller.stream;
  
  void publish(T event) {
    if (!_controller.isClosed) {
      _controller.add(event);
    }
  }
  
  void close() {
    _controller.close();
  }
}

// Stream Transformer
class ThrottleTransformer<T> extends StreamTransformerBase<T, T> {
  final Duration duration;
  
  ThrottleTransformer(this.duration);
  
  @override
  Stream<T> bind(Stream<T> stream) {
    return Stream.fromFuture(_throttle(stream));
  }
  
  Future<T> _throttle(Stream<T> stream) async {
    T? lastEvent;
    await for (var event in stream) {
      lastEvent = event;
      await Future.delayed(duration);
    }
    return lastEvent!;
  }
}

// Async generators
Stream<int> countStream(int max) async* {
  for (int i = 0; i < max; i++) {
    await Future.delayed(Duration(milliseconds: 100));
    yield i;
  }
}

Stream<int> fibonacci() async* {
  int a = 0, b = 1;
  while (true) {
    yield a;
    int temp = a;
    a = b;
    b = temp + b;
    await Future.delayed(Duration(milliseconds: 500));
  }
}

// Stream operations avançadas
Future<void> exemploStreamsAvancados() async {
  var eventBus = EventBus<String>();
  
  // Multiple subscribers
  eventBus.stream.listen((event) => print('Listener 1: $event'));
  eventBus.stream.listen((event) => print('Listener 2: $event'));
  
  // Stream transformations
  var processedStream = eventBus.stream
      .where((event) => event.length > 3)
      .map((event) => event.toUpperCase())
      .distinct()
      .take(5);
      
  processedStream.listen(
    (event) => print('Processed: $event'),
    onError: (error) => print('Error: $error'),
    onDone: () => print('Stream completed'),
  );
  
  // Publish events
  ['hi', 'hello', 'world', 'dart', 'flutter'].forEach(eventBus.publish);
  
  await Future.delayed(Duration(seconds: 1));
  eventBus.close();
  
  // Fibonacci stream
  await for (var number in fibonacci().take(10)) {
    print('Fibonacci: $number');
  }
}
```

### 4.3 Isolates e Paralelismo

```dart
import 'dart:isolate';

// Worker isolate
class WorkerIsolate {
  late SendPort _sendPort;
  late Isolate _isolate;
  final Completer<void> _readyCompleter = Completer<void>();
  
  Future<void> start() async {
    final receivePort = ReceivePort();
    _isolate = await Isolate.spawn(_isolateEntryPoint, receivePort.sendPort);
    
    _sendPort = await receivePort.first;
    _readyCompleter.complete();
  }
  
  Future<T> execute<T>(dynamic message) async {
    await _readyCompleter.future;
    
    final responsePort = ReceivePort();
    _sendPort.send({'message': message, 'replyTo': responsePort.sendPort});
    
    return await responsePort.first as T;
  }
  
  void dispose() {
    _isolate.kill(priority: Isolate.immediate);
  }
  
  static void _isolateEntryPoint(SendPort sendPort) {
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);
    
    receivePort.listen((data) {
      var message = data['message'];
      var replyTo = data['replyTo'] as SendPort;
      
      // Processamento pesado
      var result = _heavyComputation(message);
      replyTo.send(result);
    });
  }
  
  static int _heavyComputation(int n) {
    if (n <= 1) return n;
    return _heavyComputation(n - 1) + _heavyComputation(n - 2);
  }
}

// Compute function helper
Future<int> computeFibonacci(int n) {
  return compute(_fibonacciIsolate, n);
}

int _fibonacciIsolate(int n) {
  if (n <= 1) return n;
  return _fibonacciIsolate(n - 1) + _fibonacciIsolate(n - 2);
}

// Uso dos isolates
Future<void> exemploIsolates() async {
  print('Iniciando worker isolate...');
  var worker = WorkerIsolate();
  await worker.start();
  
  print('Executando computação pesada...');
  var result = await worker.execute<int>(35);
  print('Resultado: $result');
  
  worker.dispose();
  
  // Usando compute
  print('Usando compute...');
  var fibResult = await computeFibonacci(30);
  print('Fibonacci: $fibResult');
}
```

## 5. Padrões de Design em Dart

### 5.1 Singleton e Factory Patterns

```dart
// Singleton thread-safe
class DatabaseConnection {
  static DatabaseConnection? _instance;
  static final Mutex _mutex = Mutex();
  
  DatabaseConnection._internal();
  
  static Future<DatabaseConnection> getInstance() async {
    if (_instance == null) {
      await _mutex.acquire();
      try {
        _instance ??= DatabaseConnection._internal();
      } finally {
        _mutex.release();
      }
    }
    return _instance!;
  }
  
  void query(String sql) {
    print('Executing: $sql');
  }
}

// Factory Pattern
abstract class Vehicle {
  void start();
  void stop();
  
  factory Vehicle(String type) {
    switch (type.toLowerCase()) {
      case 'car':
        return Car();
      case 'motorcycle':
        return Motorcycle();
      default:
        throw ArgumentError('Unknown vehicle type: $type');
    }
  }
}

class Car implements Vehicle {
  @override
  void start() => print('Car engine started');
  
  @override
  void stop() => print('Car engine stopped');
}

class Motorcycle implements Vehicle {
  @override
  void start() => print('Motorcycle engine started');
  
  @override
  void stop() => print('Motorcycle engine stopped');
}

// Abstract Factory
abstract class UIFactory {
  Button createButton();
  TextField createTextField();
}

class AndroidUIFactory implements UIFactory {
  @override
  Button createButton() => AndroidButton();
  
  @override
  TextField createTextField() => AndroidTextField();
}

class iOSUIFactory implements UIFactory {
  @override
  Button createButton() => iOSButton();
  
  @override
  TextField createTextField() => iOSTextField();
}

abstract class Button {
  void render();
}

abstract class TextField {
  void render();
}

class AndroidButton implements Button {
  @override
  void render() => print('Rendering Android button');
}

class AndroidTextField implements TextField {
  @override
  void render() => print('Rendering Android text field');
}

class iOSButton implements Button {
  @override
  void render() => print('Rendering iOS button');
}

class iOSTextField implements TextField {
  @override
  void render() => print('Rendering iOS text field');
}
```

### 5.2 Observer Pattern com Streams

```dart
// Observable using Streams
class Observable<T> {
  final StreamController<T> _controller = StreamController<T>.broadcast();
  T _value;
  
  Observable(this._value);
  
  T get value => _value;
  
  set value(T newValue) {
    if (_value != newValue) {
      _value = newValue;
      _controller.add(newValue);
    }
  }
  
  Stream<T> get stream => _controller.stream;
  
  void dispose() {
    _controller.close();
  }
}

// Observer
abstract class Observer<T> {
  void update(T value);
}

class ConcreteObserver<T> implements Observer<T> {
  final String name;
  
  ConcreteObserver(this.name);
  
  @override
  void update(T value) {
    print('$name received update: $value');
  }
}

// Usage
void exemploObserver() {
  var observable = Observable<int>(0);
  
  var observer1 = ConcreteObserver<int>('Observer1');
  var observer2 = ConcreteObserver<int>('Observer2');
  
  // Subscribe observers
  observable.stream.listen(observer1.update);
  observable.stream.listen(observer2.update);
  
  // Update value
  observable.value = 42;
  observable.value = 100;
  
  observable.dispose();
}
```

### 5.3 Command Pattern e Memento

```dart
// Command Pattern
abstract class Command {
  void execute();
  void undo();
}

class TextEditor {
  String _content = '';
  
  String get content => _content;
  
  void insertText(String text) {
    _content += text;
  }
  
  void deleteText(int count) {
    if (count <= _content.length) {
      _content = _content.substring(0, _content.length - count);
    }
  }
  
  void replaceText(String newText) {
    _content = newText;
  }
}

class InsertTextCommand implements Command {
  final TextEditor editor;
  final String text;
  
  InsertTextCommand(this.editor, this.text);
  
  @override
  void execute() {
    editor.insertText(text);
  }
  
  @override
  void undo() {
    editor.deleteText(text.length);
  }
}

class DeleteTextCommand implements Command {
  final TextEditor editor;
  final int count;
  String? _deletedText;
  
  DeleteTextCommand(this.editor, this.count);
  
  @override
  void execute() {
    var content = editor.content;
    var startIndex = content.length - count;
    if (startIndex >= 0) {
      _deletedText = content.substring(startIndex);
      editor.deleteText(count);
    }
  }
  
  @override
  void undo() {
    if (_deletedText != null) {
      editor.insertText(_deletedText!);
    }
  }
}

// Memento Pattern
class EditorMemento {
  final String _content;
  final DateTime _timestamp;
  
  EditorMemento(this._content) : _timestamp = DateTime.now();
  
  String get content => _content;
  DateTime get timestamp => _timestamp;
}

class TextEditorWithHistory extends TextEditor {
  final List<EditorMemento> _history = [];
  int _currentIndex = -1;
  
  void saveState() {
    // Remove future states if we're not at the end
    if (_currentIndex < _history.length - 1) {
      _history.removeRange(_currentIndex + 1, _history.length);
    }
    
    _history.add(EditorMemento(content));
    _currentIndex = _history.length - 1;
  }
  
  void undo() {
    if (_currentIndex > 0) {
      _currentIndex--;
      var memento = _history[_currentIndex];
      replaceText(memento.content);
    }
  }
  
  void redo() {
    if (_currentIndex < _history.length - 1) {
      _currentIndex++;
      var memento = _history[_currentIndex];
      replaceText(memento.content);
    }
  }
}

// Command Manager
class CommandManager {
  final List<Command> _history = [];
  int _currentIndex = -1;
  
  void executeCommand(Command command) {
    command.execute();
    
    // Remove future commands if we're not at the end
    if (_currentIndex < _history.length - 1) {
      _history.removeRange(_currentIndex + 1, _history.length);
    }
    
    _history.add(command);
    _currentIndex = _history.length - 1;
  }
  
  void undo() {
    if (_currentIndex >= 0) {
      _history[_currentIndex].undo();
      _currentIndex--;
    }
  }
  
  void redo() {
    if (_currentIndex < _history.length - 1) {
      _currentIndex++;
      _history[_currentIndex].execute();
    }
  }
}
```

## 6. Estruturas de Dados Avançadas

### 6.1 Custom Collections

```dart
// Generic Stack
class Stack<T> {
  final List<T> _items = [];
  
  void push(T item) {
    _items.add(item);
  }
  
  T? pop() {
    if (isEmpty) return null;
    return _items.removeLast();
  }
  
  T? peek() {
    if (isEmpty) return null;
    return _items.last;
  }
  
  bool get isEmpty => _items.isEmpty;
  int get size => _items.length;
  
  @override
  String toString() => 'Stack($_items)';
}

// Binary Tree
class TreeNode<T> {
  T data;
  TreeNode<T>? left;
  TreeNode<T>? right;
  
  TreeNode(this.data, {this.left, this.right});
}

class BinarySearchTree<T extends Comparable<T>> {
  TreeNode<T>? _root;
  
  void insert(T data) {
    _root = _insertRecursive(_root, data);
  }
  
  TreeNode<T> _insertRecursive(TreeNode<T>? node, T data) {
    if (node == null) {
      return TreeNode<T>(data);
    }
    
    if (data.compareTo(node.data) < 0) {
      node.left = _insertRecursive(node.left, data);
    } else if (data.compareTo(node.data) > 0) {
      node.right = _insertRecursive(node.right, data);
    }
    
    return node;
  }
  
  bool contains(T data) {
    return _searchRecursive(_root, data);
  }
  
  bool _searchRecursive(TreeNode<T>? node, T data) {
    if (node == null) return false;
    
    if (data == node.data) return true;
    
    if (data.compareTo(node.data) < 0) {
      return _searchRecursive(node.left, data);
    } else {
      return _searchRecursive(node.right, data);
    }
  }
  
  List<T> inOrderTraversal() {
    var result = <T>[];
    _inOrderRecursive(_root, result);
    return result;
  }
  
  void _inOrderRecursive(TreeNode<T>? node, List<T> result) {
    if (node != null) {
      _inOrderRecursive(node.left, result);
      result.add(node.data);
      _inOrderRecursive(node.right, result);
    }
  }
}

// Trie for string search
class TrieNode {
  final Map<String, TrieNode> children = {};
  bool isEndOfWord = false;
}

class Trie {
  final TrieNode _root = TrieNode();
  
  void insert(String word) {
    var current = _root;
    for (var char in word.split('')) {
      current.children.putIfAbsent(char, () => TrieNode());
      current = current.children[char]!;
    }
    current.isEndOfWord = true;
  }
  
  bool search(String word) {
    var current = _root;
    for (var char in word.split('')) {
      if (!current.children.containsKey(char)) {
        return false;
      }
      current = current.children[char]!;
    }
    return current.isEndOfWord;
  }
  
  bool startsWith(String prefix) {
    var current = _root;
    for (var char in prefix.split('')) {
      if (!current.children.containsKey(char)) {
        return false;
      }
      current = current.children[char]!;
    }
    return true;
  }
  
  List<String> findWordsWithPrefix(String prefix) {
    var current = _root;
    var result = <String>[];
    
    // Navigate to prefix
    for (var char in prefix.split('')) {
      if (!current.children.containsKey(char)) {
        return result;
      }
      current = current.children[char]!;
    }
    
    // Find all words from this node
    _findAllWords(current, prefix, result);
    return result;
  }
  
  void _findAllWords(TrieNode node, String prefix, List<String> result) {
    if (node.isEndOfWord) {
      result.add(prefix);
    }
    
    for (var entry in node.children.entries) {
      _findAllWords(entry.value, prefix + entry.key, result);
    }
  }
}
```

### 6.2 Graph Algorithms

```dart
// Graph representation
class Graph<T> {
  final Map<T, Set<T>> _adjacencyList = {};
  
  void addVertex(T vertex) {
    _adjacencyList.putIfAbsent(vertex, () => <T>{});
  }
  
  void addEdge(T source, T destination, {bool bidirectional = false}) {
    addVertex(source);
    addVertex(destination);
    
    _adjacencyList[source]!.add(destination);
    if (bidirectional) {
      _adjacencyList[destination]!.add(source);
    }
  }
  
  Set<T> getNeighbors(T vertex) {
    return _adjacencyList[vertex] ?? <T>{};
  }
  
  // Breadth-First Search
  List<T> bfs(T start) {
    var visited = <T>{};
    var queue = <T>[start];
    var result = <T>[];
    
    while (queue.isNotEmpty) {
      var vertex = queue.removeAt(0);
      
      if (!visited.contains(vertex)) {
        visited.add(vertex);
        result.add(vertex);
        
        for (var neighbor in getNeighbors(vertex)) {
          if (!visited.contains(neighbor)) {
            queue.add(neighbor);
          }
        }
      }
    }
    
    return result;
  }
  
  // Depth-First Search
  List<T> dfs(T start) {
    var visited = <T>{};
    var result = <T>[];
    
    void dfsRecursive(T vertex) {
      visited.add(vertex);
      result.add(vertex);
      
      for (var neighbor in getNeighbors(vertex)) {
        if (!visited.contains(neighbor)) {
          dfsRecursive(neighbor);
        }
      }
    }
    
    dfsRecursive(start);
    return result;
  }
  
  // Find path between two vertices
  List<T>? findPath(T start, T end) {
    var visited = <T>{};
    var parent = <T, T?>{};
    var queue = <T>[start];
    
    parent[start] = null;
    
    while (queue.isNotEmpty) {
      var current = queue.removeAt(0);
      
      if (current == end) {
        // Reconstruct path
        var path = <T>[];
        T? node = end;
        
        while (node != null) {
          path.insert(0, node);
          node = parent[node];
        }
        
        return path;
      }
      
      if (!visited.contains(current)) {
        visited.add(current);
        
        for (var neighbor in getNeighbors(current)) {
          if (!visited.contains(neighbor) && !parent.containsKey(neighbor)) {
            parent[neighbor] = current;
            queue.add(neighbor);
          }
        }
      }
    }
    
    return null; // No path found
  }
}

// Weighted Graph for Dijkstra's Algorithm
class WeightedGraph<T> {
  final Map<T, Map<T, int>> _adjacencyList = {};
  
  void addVertex(T vertex) {
    _adjacencyList.putIfAbsent(vertex, () => <T, int>{});
  }
  
  void addEdge(T source, T destination, int weight, {bool bidirectional = false}) {
    addVertex(source);
    addVertex(destination);
    
    _adjacencyList[source]![destination] = weight;
    if (bidirectional) {
      _adjacencyList[destination]![source] = weight;
    }
  }
  
  // Dijkstra's shortest path algorithm
  Map<T, int> dijkstra(T start) {
    var distances = <T, int>{};
    var visited = <T>{};
    var priorityQueue = <MapEntry<T, int>>[];
    
    // Initialize distances
    for (var vertex in _adjacencyList.keys) {
      distances[vertex] = vertex == start ? 0 : double.maxFinite.toInt();
    }
    
    priorityQueue.add(MapEntry(start, 0));
    
    while (priorityQueue.isNotEmpty) {
      // Find minimum distance vertex
      priorityQueue.sort((a, b) => a.value.compareTo(b.value));
      var current = priorityQueue.removeAt(0);
      var currentVertex = current.key;
      
      if (visited.contains(currentVertex)) continue;
      visited.add(currentVertex);
      
      // Update distances to neighbors
      for (var neighbor in _adjacencyList[currentVertex]!.entries) {
        var neighborVertex = neighbor.key;
        var weight = neighbor.value;
        var newDistance = distances[currentVertex]! + weight;
        
        if (newDistance < distances[neighborVertex]!) {
          distances[neighborVertex] = newDistance;
          priorityQueue.add(MapEntry(neighborVertex, newDistance));
        }
      }
    }
    
    return distances;
  }
}
```

## 7. Functional Programming Avançado

### 7.1 Monads e Functional Error Handling

```dart
// Result Monad for error handling
abstract class Result<T, E> {
  bool get isSuccess;
  bool get isFailure => !isSuccess;
  
  T get value;
  E get error;
  
  // Functor map
  Result<U, E> map<U>(U Function(T) transform);
  
  // Monad flatMap
  Result<U, E> flatMap<U>(Result<U, E> Function(T) transform);
  
  // Handle errors
  Result<T, E> orElse(Result<T, E> Function(E) handler);
}

class Success<T, E> implements Result<T, E> {
  final T _value;
  
  Success(this._value);
  
  @override
  bool get isSuccess => true;
  
  @override
  T get value => _value;
  
  @override
  E get error => throw StateError('Success has no error');
  
  @override
  Result<U, E> map<U>(U Function(T) transform) {
    try {
      return Success(transform(_value));
    } catch (e) {
      return Failure(e as E);
    }
  }
  
  @override
  Result<U, E> flatMap<U>(Result<U, E> Function(T) transform) {
    try {
      return transform(_value);
    } catch (e) {
      return Failure(e as E);
    }
  }
  
  @override
  Result<T, E> orElse(Result<T, E> Function(E) handler) => this;
  
  @override
  String toString() => 'Success($_value)';
}

class Failure<T, E> implements Result<T, E> {
  final E _error;
  
  Failure(this._error);
  
  @override
  bool get isSuccess => false;
  
  @override
  T get value => throw StateError('Failure has no value');
  
  @override
  E get error => _error;
  
  @override
  Result<U, E> map<U>(U Function(T) transform) => Failure(_error);
  
  @override
  Result<U, E> flatMap<U>(Result<U, E> Function(T) transform) => Failure(_error);
  
  @override
  Result<T, E> orElse(Result<T, E> Function(E) handler) => handler(_error);
  
  @override
  String toString() => 'Failure($_error)';
}

// Option Monad for null handling
abstract class Option<T> {
  bool get isSome;
  bool get isNone => !isSome;
  
  T get value;
  
  Option<U> map<U>(U Function(T) transform);
  Option<U> flatMap<U>(Option<U> Function(T) transform);
  T getOrElse(T defaultValue);
  Option<T> filter(bool Function(T) predicate);
}

class Some<T> implements Option<T> {
  final T _value;
  
  Some(this._value);
  
  @override
  bool get isSome => true;
  
  @override
  T get value => _value;
  
  @override
  Option<U> map<U>(U Function(T) transform) {
    try {
      return Some(transform(_value));
    } catch (e) {
      return None();
    }
  }
  
  @override
  Option<U> flatMap<U>(Option<U> Function(T) transform) {
    try {
      return transform(_value);
    } catch (e) {
      return None();
    }
  }
  
  @override
  T getOrElse(T defaultValue) => _value;
  
  @override
  Option<T> filter(bool Function(T) predicate) {
    return predicate(_value) ? this : None();
  }
  
  @override
  String toString() => 'Some($_value)';
}

class None<T> implements Option<T> {
  @override
  bool get isSome => false;
  
  @override
  T get value => throw StateError('None has no value');
  
  @override
  Option<U> map<U>(U Function(T) transform) => None();
  
  @override
  Option<U> flatMap<U>(Option<U> Function(T) transform) => None();
  
  @override
  T getOrElse(T defaultValue) => defaultValue;
  
  @override
  Option<T> filter(bool Function(T) predicate) => this;
  
  @override
  String toString() => 'None';
}

// Example usage of monads
Future<Result<User, String>> fetchUser(String id) async {
  try {
    // Simulate API call
    await Future.delayed(Duration(milliseconds: 100));
    
    if (id.isEmpty) {
      return Failure('ID cannot be empty');
    }
    
    if (id == 'invalid') {
      return Failure('User not found');
    }
    
    return Success(User(id, 'User $id'));
  } catch (e) {
    return Failure('Network error: $e');
  }
}

class User {
  final String id;
  final String name;
  
  User(this.id, this.name);
  
  @override
  String toString() => 'User(id: $id, name: $name)';
}

Future<void> exemploMonads() async {
  // Using Result monad
  var userResult = await fetchUser('123');
  
  var processedResult = userResult
      .map((user) => user.name.toUpperCase())
      .flatMap((name) => Success('Welcome, $name!'))
      .orElse((error) => Success('Welcome, Guest! (Error: $error)'));
  
  print(processedResult); // Success(Welcome, USER 123!)
  
  // Using Option monad
  Option<String> findUserEmail(String userId) {
    var emails = {'123': 'user@example.com', '456': 'admin@example.com'};
    var email = emails[userId];
    return email != null ? Some(email) : None();
  }
  
  var emailResult = findUserEmail('123')
      .map((email) => email.toUpperCase())
      .filter((email) => email.contains('@'))
      .getOrElse('no-email@example.com');
  
  print(emailResult); // USER@EXAMPLE.COM
}
```

### 7.2 Immutable Data Structures

```dart
// Immutable List
class ImmutableList<T> {
  final List<T> _items;
  
  const ImmutableList(this._items);
  
  factory ImmutableList.empty() => const ImmutableList([]);
  
  factory ImmutableList.from(Iterable<T> items) => ImmutableList(List.unmodifiable(items));
  
  int get length => _items.length;
  bool get isEmpty => _items.isEmpty;
  
  T operator [](int index) => _items[index];
  
  ImmutableList<T> add(T item) {
    return ImmutableList([..._items, item]);
  }
  
  ImmutableList<T> addAll(Iterable<T> items) {
    return ImmutableList([..._items, ...items]);
  }
  
  ImmutableList<T> removeAt(int index) {
    var newList = List<T>.from(_items);
    newList.removeAt(index);
    return ImmutableList(newList);
  }
  
  ImmutableList<T> remove(T item) {
    var newList = List<T>.from(_items);
    newList.remove(item);
    return ImmutableList(newList);
  }
  
  ImmutableList<T> where(bool Function(T) test) {
    return ImmutableList(_items.where(test).toList());
  }
  
  ImmutableList<U> map<U>(U Function(T) transform) {
    return ImmutableList(_items.map(transform).toList());
  }
  
  T fold<T>(T initialValue, T Function(T, T) combine) {
    return _items.fold(initialValue, combine);
  }
  
  @override
  String toString() => 'ImmutableList($_items)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ImmutableList<T>) return false;
    
    if (_items.length != other._items.length) return false;
    for (int i = 0; i < _items.length; i++) {
      if (_items[i] != other._items[i]) return false;
    }
    return true;
  }
  
  @override
  int get hashCode => Object.hashAll(_items);
}

// Immutable Map
class ImmutableMap<K, V> {
  final Map<K, V> _map;
  
  const ImmutableMap(this._map);
  
  factory ImmutableMap.empty() => const ImmutableMap({});
  
  factory ImmutableMap.from(Map<K, V> map) => ImmutableMap(Map.unmodifiable(map));
  
  int get length => _map.length;
  bool get isEmpty => _map.isEmpty;
  
  Iterable<K> get keys => _map.keys;
  Iterable<V> get values => _map.values;
  
  V? operator [](K key) => _map[key];
  
  bool containsKey(K key) => _map.containsKey(key);
  
  ImmutableMap<K, V> put(K key, V value) {
    return ImmutableMap({..._map, key: value});
  }
  
  ImmutableMap<K, V> putAll(Map<K, V> other) {
    return ImmutableMap({..._map, ...other});
  }
  
  ImmutableMap<K, V> remove(K key) {
    var newMap = Map<K, V>.from(_map);
    newMap.remove(key);
    return ImmutableMap(newMap);
  }
  
  ImmutableMap<K, U> mapValues<U>(U Function(V) transform) {
    var newMap = <K, U>{};
    for (var entry in _map.entries) {
      newMap[entry.key] = transform(entry.value);
    }
    return ImmutableMap(newMap);
  }
  
  @override
  String toString() => 'ImmutableMap($_map)';
}

// Record-like class for immutable data
class Person {
  final String name;
  final int age;
  final String email;
  
  const Person({
    required this.name,
    required this.age,
    required this.email,
  });
  
  // Copy with method for immutable updates
  Person copyWith({
    String? name,
    int? age,
    String? email,
  }) {
    return Person(
      name: name ?? this.name,
      age: age ?? this.age,
      email: email ?? this.email,
    );
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Person &&
        other.name == name &&
        other.age == age &&
        other.email == email;
  }
  
  @override
  int get hashCode => Object.hash(name, age, email);
  
  @override
  String toString() => 'Person(name: $name, age: $age, email: $email)';
}
```

## 8. Testing Avançado e Quality Assurance

### 8.1 Unit Testing Abrangente

```dart
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

// Service para testar
class UserService {
  final DatabaseRepository repository;
  final EmailService emailService;
  
  UserService(this.repository, this.emailService);
  
  Future<Result<User, String>> createUser(String name, String email) async {
    if (name.isEmpty) {
      return Failure('Name cannot be empty');
    }
    
    if (!_isValidEmail(email)) {
      return Failure('Invalid email format');
    }
    
    try {
      var existingUser = await repository.findByEmail(email);
      if (existingUser != null) {
        return Failure('User already exists');
      }
      
      var user = User(DateTime.now().millisecondsSinceEpoch.toString(), name);
      await repository.save(user);
      await emailService.sendWelcomeEmail(email);
      
      return Success(user);
    } catch (e) {
      return Failure('Failed to create user: $e');
    }
  }
  
  bool _isValidEmail(String email) {
    return email.contains('@') && email.contains('.');
  }
}

abstract class DatabaseRepository {
  Future<User?> findByEmail(String email);
  Future<void> save(User user);
}

abstract class EmailService {
  Future<void> sendWelcomeEmail(String email);
}

// Mocks
class MockDatabaseRepository extends Mock implements DatabaseRepository {}
class MockEmailService extends Mock implements EmailService {}

void main() {
  group('UserService Tests', () {
    late UserService userService;
    late MockDatabaseRepository mockRepository;
    late MockEmailService mockEmailService;
    
    setUp(() {
      mockRepository = MockDatabaseRepository();
      mockEmailService = MockEmailService();
      userService = UserService(mockRepository, mockEmailService);
    });
    
    group('createUser', () {
      test('should return failure when name is empty', () async {
        // Act
        var result = await userService.createUser('', 'test@example.com');
        
        // Assert
        expect(result.isFailure, isTrue);
        expect(result.error, equals('Name cannot be empty'));
        verifyNever(mockRepository.findByEmail(any));
      });
      
      test('should return failure when email is invalid', () async {
        // Act
        var result = await userService.createUser('John', 'invalid-email');
        
        // Assert
        expect(result.isFailure, isTrue);
        expect(result.error, equals('Invalid email format'));
        verifyNever(mockRepository.findByEmail(any));
      });
      
      test('should return failure when user already exists', () async {
        // Arrange
        var existingUser = User('1', 'Existing User');
        when(mockRepository.findByEmail('test@example.com'))
            .thenAnswer((_) async => existingUser);
        
        // Act
        var result = await userService.createUser('John', 'test@example.com');
        
        // Assert
        expect(result.isFailure, isTrue);
        expect(result.error, equals('User already exists'));
        verify(mockRepository.findByEmail('test@example.com')).called(1);
        verifyNever(mockRepository.save(any));
      });
      
      test('should create user successfully', () async {
        // Arrange
        when(mockRepository.findByEmail('test@example.com'))
            .thenAnswer((_) async => null);
        when(mockRepository.save(any)).thenAnswer((_) async {});
        when(mockEmailService.sendWelcomeEmail(any)).thenAnswer((_) async {});
        
        // Act
        var result = await userService.createUser('John', 'test@example.com');
        
        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value.name, equals('John'));
        verify(mockRepository.findByEmail('test@example.com')).called(1);
        verify(mockRepository.save(any)).called(1);
        verify(mockEmailService.sendWelcomeEmail('test@example.com')).called(1);
      });
      
      test('should handle repository exception', () async {
        // Arrange
        when(mockRepository.findByEmail('test@example.com'))
            .thenThrow(Exception('Database error'));
        
        // Act
        var result = await userService.createUser('John', 'test@example.com');
        
        // Assert
        expect(result.isFailure, isTrue);
        expect(result.error, contains('Failed to create user'));
        verifyNever(mockRepository.save(any));
        verifyNever(mockEmailService.sendWelcomeEmail(any));
      });
    });
  });
  
  group('BinarySearchTree Tests', () {
    late BinarySearchTree<int> bst;
    
    setUp(() {
      bst = BinarySearchTree<int>();
    });
    
    test('should insert and find elements correctly', () {
      // Arrange & Act
      bst.insert(5);
      bst.insert(3);
      bst.insert(7);
      bst.insert(1);
      bst.insert(9);
      
      // Assert
      expect(bst.contains(5), isTrue);
      expect(bst.contains(3), isTrue);
      expect(bst.contains(7), isTrue);
      expect(bst.contains(1), isTrue);
      expect(bst.contains(9), isTrue);
      expect(bst.contains(6), isFalse);
    });
    
    test('should return elements in sorted order', () {
      // Arrange
      var numbers = [5, 3, 7, 1, 9, 4, 6];
      for (var num in numbers) {
        bst.insert(num);
      }
      
      // Act
      var sortedNumbers = bst.inOrderTraversal();
      
      // Assert
      expect(sortedNumbers, equals([1, 3, 4, 5, 6, 7, 9]));
    });
  });
  
  group('Custom Matchers', () {
    test('should match custom conditions', () {
      var user = User('1', 'John Doe');
      
      expect(user, isValidUser());
      expect(user.name, hasLength(greaterThan(0)));
    });
  });
}

// Custom matcher
class IsValidUser extends Matcher {
  @override
  bool matches(dynamic item, Map matchState) {
    if (item is! User) return false;
    return item.id.isNotEmpty && item.name.isNotEmpty;
  }
  
  @override
  Description describe(Description description) {
    return description.add('a valid user with id and name');
  }
}

Matcher isValidUser() => IsValidUser();
```

### 8.2 Integration Testing

```dart
// Integration test exemplo
import 'package:test/test.dart';
import 'dart:io';

class FileManager {
  Future<void> writeToFile(String path, String content) async {
    var file = File(path);
    await file.writeAsString(content);
  }
  
  Future<String> readFromFile(String path) async {
    var file = File(path);
    return await file.readAsString();
  }
  
  Future<bool> fileExists(String path) async {
    var file = File(path);
    return await file.exists();
  }
  
  Future<void> deleteFile(String path) async {
    var file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }
}

void integrationTests() {
  group('FileManager Integration Tests', () {
    late FileManager fileManager;
    late String testFilePath;
    
    setUp(() {
      fileManager = FileManager();
      testFilePath = 'test_${DateTime.now().millisecondsSinceEpoch}.txt';
    });
    
    tearDown(() async {
      // Cleanup
      await fileManager.deleteFile(testFilePath);
    });
    
    test('should write and read file correctly', () async {
      // Arrange
      var content = 'Hello, Dart!';
      
      // Act
      await fileManager.writeToFile(testFilePath, content);
      var readContent = await fileManager.readFromFile(testFilePath);
      
      // Assert
      expect(readContent, equals(content));
      expect(await fileManager.fileExists(testFilePath), isTrue);
    });
    
    test('should handle file operations in sequence', () async {
      // Test complete workflow
      var initialContent = 'Initial content';
      var updatedContent = 'Updated content';
      
      // Write initial content
      await fileManager.writeToFile(testFilePath, initialContent);
      expect(await fileManager.readFromFile(testFilePath), equals(initialContent));
      
      // Update content
      await fileManager.writeToFile(testFilePath, updatedContent);
      expect(await fileManager.readFromFile(testFilePath), equals(updatedContent));
      
      // Delete file
      await fileManager.deleteFile(testFilePath);
      expect(await fileManager.fileExists(testFilePath), isFalse);
    });
  });
}
```

### 8.3 Performance Testing e Benchmarking

```dart
import 'dart:math';

class PerformanceTester {
  static Future<Duration> measureAsync(Future<void> Function() operation) async {
    var stopwatch = Stopwatch()..start();
    await operation();
    stopwatch.stop();
    return stopwatch.elapsed;
  }
  
  static Duration measure(void Function() operation) {
    var stopwatch = Stopwatch()..start();
    operation();
    stopwatch.stop();
    return stopwatch.elapsed;
  }
  
  static Future<BenchmarkResult> benchmark({
    required String name,
    required Future<void> Function() operation,
    int iterations = 1000,
  }) async {
    var times = <Duration>[];
    
    // Warmup
    for (int i = 0; i < 10; i++) {
      await operation();
    }
    
    // Actual benchmark
    for (int i = 0; i < iterations; i++) {
      var time = await measureAsync(operation);
      times.add(time);
    }
    
    return BenchmarkResult(name, times);
  }
}

class BenchmarkResult {
  final String name;
  final List<Duration> times;
  
  BenchmarkResult(this.name, this.times);
  
  Duration get average {
    var totalMicroseconds = times.fold(0, (sum, time) => sum + time.inMicroseconds);
    return Duration(microseconds: totalMicroseconds ~/ times.length);
  }
  
  Duration get min => times.reduce((a, b) => a < b ? a : b);
  Duration get max => times.reduce((a, b) => a > b ? a : b);
  
  Duration get median {
    var sorted = List<Duration>.from(times)..sort();
    var middle = sorted.length ~/ 2;
    return sorted[middle];
  }
  
  Duration get standardDeviation {
    var avg = average.inMicroseconds;
    var variance = times
        .map((time) => pow(time.inMicroseconds - avg, 2))
        .reduce((a, b) => a + b) / times.length;
    return Duration(microseconds: sqrt(variance).round());
  }
  
  @override
  String toString() {
    return '''
Benchmark: $name
Iterations: ${times.length}
Average: ${average.inMicroseconds}μs
Median: ${median.inMicroseconds}μs
Min: ${min.inMicroseconds}μs
Max: ${max.inMicroseconds}μs
Std Dev: ${standardDeviation.inMicroseconds}μs
''';
  }
}

// Example performance tests
Future<void> performanceTests() async {
  // Test different list operations
  var listAddResult = await PerformanceTester.benchmark(
    name: 'List Add Operations',
    operation: () async {
      var list = <int>[];
      for (int i = 0; i < 1000; i++) {
        list.add(i);
      }
    },
  );
  
  var setAddResult = await PerformanceTester.benchmark(
    name: 'Set Add Operations',
    operation: () async {
      var set = <int>{};
      for (int i = 0; i < 1000; i++) {
        set.add(i);
      }
    },
  );
  
  print(listAddResult);
  print(setAddResult);
  
  // Test our custom data structures
  var bstResult = await PerformanceTester.benchmark(
    name: 'Binary Search Tree Insert',
    operation: () async {
      var bst = BinarySearchTree<int>();
      var random = Random();
      for (int i = 0; i < 100; i++) {
        bst.insert(random.nextInt(1000));
      }
    },
  );
  
  print(bstResult);
}
```

## 9. Concorrência e Paralelismo Avançado

### 9.1 Worker Pool Implementation

```dart
import 'dart:isolate';
import 'dart:async';

class WorkerPool {
  final int _poolSize;
  final List<Worker> _workers = [];
  final Queue<WorkItem> _queue = Queue<WorkItem>();
  bool _isShutdown = false;
  
  WorkerPool(this._poolSize);
  
  Future<void> start() async {
    for (int i = 0; i < _poolSize; i++) {
      var worker = Worker(i);
      await worker.start();
      _workers.add(worker);
    }
    _processQueue();
  }
  
  Future<T> execute<T>(dynamic message) {
    if (_isShutdown) {
      throw StateError('WorkerPool is shutdown');
    }
    
    var completer = Completer<T>();
    var workItem = WorkItem<T>(message, completer);
    _queue.add(workItem);
    
    return completer.future;
  }
  
  void _processQueue() {
    Timer.periodic(Duration(milliseconds: 10), (timer) {
      if (_isShutdown) {
        timer.cancel();
        return;
      }
      
      while (_queue.isNotEmpty) {
        var availableWorker = _workers.firstWhere(
          (worker) => worker.isAvailable,
          orElse: () => null,
        );
        
        if (availableWorker != null) {
          var workItem = _queue.removeFirst();
          availableWorker.execute(workItem);
        } else {
          break;
        }
      }
    });
  }
  
  Future<void> shutdown() async {
    _isShutdown = true;
    
    // Wait for all workers to complete current tasks
    while (_workers.any((worker) => !worker.isAvailable)) {
      await Future.delayed(Duration(milliseconds: 10));
    }
    
    // Shutdown all workers
    for (var worker in _workers) {
      worker.shutdown();
    }
  }
}

class WorkItem<T> {
  final dynamic message;
  final Completer<T> completer;
  
  WorkItem(this.message, this.completer);
}

class Worker {
  final int id;
  late Isolate _isolate;
  late SendPort _sendPort;
  late ReceivePort _receivePort;
  bool _isAvailable = true;
  bool _isInitialized = false;
  
  Worker(this.id);
  
  bool get isAvailable => _isAvailable && _isInitialized;
  
  Future<void> start() async {
    _receivePort = ReceivePort();
    _isolate = await Isolate.spawn(_isolateEntryPoint, _receivePort.sendPort);
    
    await for (var message in _receivePort) {
      if (message is SendPort) {
        _sendPort = message;
        _isInitialized = true;
        break;
      }
    }
  }
  
  void execute<T>(WorkItem<T> workItem) {
    if (!isAvailable) {
      throw StateError('Worker is not available');
    }
    
    _isAvailable = false;
    
    var responsePort = ReceivePort();
    _sendPort.send({
      'message': workItem.message,
      'replyTo': responsePort.sendPort,
    });
    
    responsePort.listen((response) {
      _isAvailable = true;
      responsePort.close();
      
      if (response is Map && response.containsKey('error')) {
        workItem.completer.completeError(response['error']);
      } else {
        workItem.completer.complete(response);
      }
    });
  }
  
  void shutdown() {
    _isolate.kill(priority: Isolate.immediate);
    _receivePort.close();
  }
  
  static void _isolateEntryPoint(SendPort sendPort) {
    var receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);
    
    receivePort.listen((data) {
      var message = data['message'];
      var replyTo = data['replyTo'] as SendPort;
      
      try {
        // Process the message
        var result = _processMessage(message);
        replyTo.send(result);
      } catch (e, stackTrace) {
        replyTo.send({'error': e.toString(), 'stackTrace': stackTrace.toString()});
      }
    });
  }
  
  static dynamic _processMessage(dynamic message) {
    // Example processing - can be customized
    if (message is Map && message['type'] == 'fibonacci') {
      return _fibonacci(message['n']);
    } else if (message is Map && message['type'] == 'prime') {
      return _isPrime(message['n']);
    } else if (message is Map && message['type'] == 'sort') {
      var list = List<int>.from(message['list']);
      list.sort();
      return list;
    }
    
    return 'Unknown message type';
  }
  
  static int _fibonacci(int n) {
    if (n <= 1) return n;
    return _fibonacci(n - 1) + _fibonacci(n - 2);
  }
  
  static bool _isPrime(int n) {
    if (n < 2) return false;
    for (int i = 2; i * i <= n; i++) {
      if (n % i == 0) return false;
    }
    return true;
  }
}

// Example usage of WorkerPool
Future<void> exemploWorkerPool() async {
  var pool = WorkerPool(4);
  await pool.start();
  
  print('Worker pool started with 4 workers');
  
  // Execute multiple tasks in parallel
  var futures = <Future>[];
  
  // Fibonacci calculations
  for (int i = 30; i <= 35; i++) {
    futures.add(pool.execute({'type': 'fibonacci', 'n': i}));
  }
  
  // Prime checks
  for (int i = 1000000; i <= 1000010; i++) {
    futures.add(pool.execute({'type': 'prime', 'n': i}));
  }
  
  // Sorting
  var randomList = List.generate(1000, (index) => Random().nextInt(10000));
  futures.add(pool.execute({'type': 'sort', 'list': randomList}));
  
  var results = await Future.wait(futures);
  
  print('All tasks completed:');
  for (int i = 0; i < results.length; i++) {
    print('Task $i: ${results[i]}');
  }
  
  await pool.shutdown();
  print('Worker pool shutdown');
}
```

### 9.2 Reactive Streams com RxDart Patterns

```dart
import 'dart:async';

// Custom Stream operators
extension StreamExtensions<T> on Stream<T> {
  Stream<T> throttle(Duration duration) {
    return transform(ThrottleStreamTransformer<T>(duration));
  }
  
  Stream<T> debounce(Duration duration) {
    return transform(DebounceStreamTransformer<T>(duration));
  }
  
  Stream<List<T>> buffer(Duration duration) {
    return transform(BufferStreamTransformer<T>(duration));
  }
  
  Stream<T> retry(int maxRetries) {
    return transform(RetryStreamTransformer<T>(maxRetries));
  }
}

class ThrottleStreamTransformer<T> extends StreamTransformerBase<T, T> {
  final Duration duration;
  
  ThrottleStreamTransformer(this.duration);
  
  @override
  Stream<T> bind(Stream<T> stream) {
    late StreamController<T> controller;
    late StreamSubscription<T> subscription;
    Timer? timer;
    bool canEmit = true;
    
    controller = StreamController<T>(
      onListen: () {
        subscription = stream.listen(
          (data) {
            if (canEmit) {
              controller.add(data);
              canEmit = false;
              timer = Timer(duration, () {
                canEmit = true;
              });
            }
          },
          onError: controller.addError,
          onDone: () {
            timer?.cancel();
            controller.close();
          },
        );
      },
      onCancel: () {
        subscription.cancel();
        timer?.cancel();
      },
    );
    
    return controller.stream;
  }
}

class DebounceStreamTransformer<T> extends StreamTransformerBase<T, T> {
  final Duration duration;
  
  DebounceStreamTransformer(this.duration);
  
  @override
  Stream<T> bind(Stream<T> stream) {
    late StreamController<T> controller;
    late StreamSubscription<T> subscription;
    Timer? timer;
    
    controller = StreamController<T>(
      onListen: () {
        subscription = stream.listen(
          (data) {
            timer?.cancel();
            timer = Timer(duration, () {
              controller.add(data);
            });
          },
          onError: controller.addError,
          onDone: () {
            timer?.cancel();
            controller.close();
          },
        );
      },
      onCancel: () {
        subscription.cancel();
        timer?.cancel();
      },
    );
    
    return controller.stream;
  }
}

class BufferStreamTransformer<T> extends StreamTransformerBase<T, List<T>> {
  final Duration duration;
  
  BufferStreamTransformer(this.duration);
  
  @override
  Stream<List<T>> bind(Stream<T> stream) {
    late StreamController<List<T>> controller;
    late StreamSubscription<T> subscription;
    Timer? timer;
    List<T> buffer = [];
    
    void emitBuffer() {
      if (buffer.isNotEmpty) {
        controller.add(List.from(buffer));
        buffer.clear();
      }
    }
    
    controller = StreamController<List<T>>(
      onListen: () {
        timer = Timer.periodic(duration, (_) => emitBuffer());
        
        subscription = stream.listen(
          (data) {
            buffer.add(data);
          },
          onError: controller.addError,
          onDone: () {
            timer?.cancel();
            emitBuffer();
            controller.close();
          },
        );
      },
      onCancel: () {
        subscription.cancel();
        timer?.cancel();
      },
    );
    
    return controller.stream;
  }
}

class RetryStreamTransformer<T> extends StreamTransformerBase<T, T> {
  final int maxRetries;
  
  RetryStreamTransformer(this.maxRetries);
  
  @override
  Stream<T> bind(Stream<T> stream) {
    return Stream.fromFuture(_retryLogic(stream));
  }
  
  Future<T> _retryLogic(Stream<T> stream) async {
    Exception? lastException;
    
    for (int attempt = 0; attempt <= maxRetries; attempt++) {
      try {
        await for (var value in stream) {
          return value; // Return first successful value
        }
      } catch (e) {
        lastException = e is Exception ? e : Exception(e.toString());
        if (attempt == maxRetries) {
          throw lastException;
        }
        await Future.delayed(Duration(milliseconds: 100 * (attempt + 1)));
      }
    }
    
    throw lastException ?? Exception('Stream retry failed');
  }
}

// Reactive State Management
class ReactiveState<T> {
  final BehaviorSubject<T> _subject;
  
  ReactiveState(T initialValue) : _subject = BehaviorSubject<T>.seeded(initialValue);
  
  T get value => _subject.value;
  Stream<T> get stream => _subject.stream;
  
  void update(T newValue) {
    if (_subject.value != newValue) {
      _subject.add(newValue);
    }
  }
  
  void updateWith(T Function(T current) updater) {
    update(updater(_subject.value));
  }
  
  void dispose() {
    _subject.close();
  }
}

class BehaviorSubject<T> {
  late StreamController<T> _controller;
  late T _value;
  
  BehaviorSubject.seeded(T initialValue) : _value = initialValue {
    _controller = StreamController<T>.broadcast(
      onListen: () {
        _controller.add(_value);
      },
    );
  }
  
  T get value => _value;
  Stream<T> get stream => _controller.stream;
  
  void add(T value) {
    _value = value;
    _controller.add(value);
  }
  
  void close() {
    _controller.close();
  }
}

// Example: Reactive Counter
class ReactiveCounter {
  final ReactiveState<int> _count = ReactiveState(0);
  late final Stream<String> _message;
  
  ReactiveCounter() {
    _message = _count.stream
        .map((count) => count % 2 == 0 ? 'Even: $count' : 'Odd: $count')
        .distinct();
  }
  
  Stream<int> get count => _count.stream;
  Stream<String> get message => _message;
  
  void increment() => _count.updateWith((current) => current + 1);
  void decrement() => _count.updateWith((current) => current - 1);
  void reset() => _count.update(0);
  
  void dispose() {
    _count.dispose();
  }
}
```

## 10. Network Programming e APIs

### 10.1 HTTP Client Avançado

```dart
import 'dart:convert';
import 'dart:io';

class HttpClient {
  final String baseUrl;
  final Map<String, String> _defaultHeaders;
  final Duration timeout;
  final int maxRetries;
  
  HttpClient({
    required this.baseUrl,
    Map<String, String>? headers,
    this.timeout = const Duration(seconds: 30),
    this.maxRetries = 3,
  }) : _defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    ...?headers,
  };
  
  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
    T Function(Map<String, dynamic>)? parser,
  }) async {
    return _makeRequest<T>(
      'GET',
      endpoint,
      headers: headers,
      queryParams: queryParams,
      parser: parser,
    );
  }
  
  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    T Function(Map<String, dynamic>)? parser,
  }) async {
    return _makeRequest<T>(
      'POST',
      endpoint,
      headers: headers,
      body: body,
      parser: parser,
    );
  }
  
  Future<ApiResponse<T>> put<T>(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    T Function(Map<String, dynamic>)? parser,
  }) async {
    return _makeRequest<T>(
      'PUT',
      endpoint,
      headers: headers,
      body: body,
      parser: parser,
    );
  }
  
  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    Map<String, String>? headers,
    T Function(Map<String, dynamic>)? parser,
  }) async {
    return _makeRequest<T>(
      'DELETE',
      endpoint,
      headers: headers,
      parser: parser,
    );
  }
  
  Future<ApiResponse<T>> _makeRequest<T>(
    String method,
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? body,
    T Function(Map<String, dynamic>)? parser,
  }) async {
    var uri = _buildUri(endpoint, queryParams);
    var requestHeaders = {..._defaultHeaders, ...?headers};
    
    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        var client = HttpClient();
        var request = await client.openUrl(method, uri);
        
        requestHeaders.forEach((key, value) {
          request.headers.set(key, value);
        });
        
        if (body != null) {
          var jsonBody = jsonEncode(body);
          request.write(jsonBody);
        }
        
        var response = await request.close().timeout(timeout);
        var responseBody = await response.transform(utf8.decoder).join();
        
        client.close();
        
        if (response.statusCode >= 200 && response.statusCode < 300) {
          var data = responseBody.isNotEmpty ? jsonDecode(responseBody) : null;
          
          T? parsedData;
          if (data != null && parser != null) {
            parsedData = parser(data as Map<String, dynamic>);
          }
          
          return ApiResponse<T>.success(
            data: parsedData,
            statusCode: response.statusCode,
            headers: _parseHeaders(response.headers),
            rawData: data,
          );
        } else {
          var errorData = responseBody.isNotEmpty ? jsonDecode(responseBody) : null;
          return ApiResponse<T>.error(
            message: 'HTTP ${response.statusCode}',
            statusCode: response.statusCode,
            errorData: errorData,
          );
        }
      } catch (e) {
        if (attempt == maxRetries) {
          return ApiResponse<T>.error(
            message: 'Request failed after $maxRetries attempts: $e',
            exception: e,
          );
        }
        
        // Exponential backoff
        await Future.delayed(Duration(milliseconds: 100 * (1 << (attempt - 1))));
      }
    }
    
    throw StateError('Should not reach here');
  }
  
  Uri _buildUri(String endpoint, Map<String, dynamic>? queryParams) {
    var url = baseUrl.endsWith('/') ? baseUrl : '$baseUrl/';
    url += endpoint.startsWith('/') ? endpoint.substring(1) : endpoint;
    
    if (queryParams != null && queryParams.isNotEmpty) {
      var queryString = queryParams.entries
          .map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}')
          .join('&');
      url += '?$queryString';
    }
    
    return Uri.parse(url);
  }
  
  Map<String, String> _parseHeaders(HttpHeaders headers) {
    var result = <String, String>{};
    headers.forEach((name, values) {
      result[name] = values.join(', ');
    });
    return result;
  }
}

class ApiResponse<T> {
  final bool isSuccess;
  final T? data;
  final String? message;
  final int? statusCode;
  final Map<String, String>? headers;
  final dynamic rawData;
  final dynamic errorData;
  final dynamic exception;
  
  ApiResponse._({
    required this.isSuccess,
    this.data,
    this.message,
    this.statusCode,
    this.headers,
    this.rawData,
    this.errorData,
    this.exception,
  });
  
  factory ApiResponse.success({
    T? data,
    required int statusCode,
    Map<String, String>? headers,
    dynamic rawData,
  }) {
    return ApiResponse._(
      isSuccess: true,
      data: data,
      statusCode: statusCode,
      headers: headers,
      rawData: rawData,
    );
  }
  
  factory ApiResponse.error({
    required String message,
    int? statusCode,
    dynamic errorData,
    dynamic exception,
  }) {
    return ApiResponse._(
      isSuccess: false,
      message: message,
      statusCode: statusCode,
      errorData: errorData,
      exception: exception,
    );
  }
  
  @override
  String toString() {
    if (isSuccess) {
      return 'ApiResponse.success(data: $data, statusCode: $statusCode)';
    } else {
      return 'ApiResponse.error(message: $message, statusCode: $statusCode)';
    }
  }
}

// Repository Pattern with HTTP Client
abstract class Repository<T, ID> {
  Future<ApiResponse<List<T>>> findAll();
  Future<ApiResponse<T?>> findById(ID id);
  Future<ApiResponse<T>> create(T entity);
  Future<ApiResponse<T>> update(ID id, T entity);
  Future<ApiResponse<void>> delete(ID id);
}

class UserRepository implements Repository<User, String> {
  final HttpClient _httpClient;
  
  UserRepository(this._httpClient);
  
  @override
  Future<ApiResponse<List<User>>> findAll() async {
    var response = await _httpClient.get<List<User>>(
      'users',
      parser: (data) {
        var usersList = data['users'] as List;
        return usersList.map((json) => User.fromJson(json)).toList();
      },
    );
    
    if (response.isSuccess && response.rawData != null) {
      var usersList = response.rawData['users'] as List;
      var users = usersList.map((json) => User.fromJson(json)).toList();
      return ApiResponse.success(data: users, statusCode: response.statusCode!);
    }
    
    return ApiResponse.error(message: response.message ?? 'Failed to fetch users');
  }
  
  @override
  Future<ApiResponse<User?>> findById(String id) async {
    var response = await _httpClient.get<User>(
      'users/$id',
      parser: (data) => User.fromJson(data),
    );
    
    if (response.isSuccess) {
      return response;
    }
    
    if (response.statusCode == 404) {
      return ApiResponse.success(data: null, statusCode: response.statusCode!);
    }
    
    return ApiResponse.error(message: response.message ?? 'Failed to fetch user');
  }
  
  @override
  Future<ApiResponse<User>> create(User entity) async {
    return await _httpClient.post<User>(
      'users',
      body: entity.toJson(),
      parser: (data) => User.fromJson(data),
    );
  }
  
  @override
  Future<ApiResponse<User>> update(String id, User entity) async {
    return await _httpClient.put<User>(
      'users/$id',
      body: entity.toJson(),
      parser: (data) => User.fromJson(data),
    );
  }
  
  @override
  Future<ApiResponse<void>> delete(String id) async {
    var response = await _httpClient.delete('users/$id');
    return ApiResponse<void>.success(statusCode: response.statusCode!);
  }
}

// User model with serialization
class User {
  final String id;
  final String name;
  final String email;
  final DateTime? createdAt;
  
  User(this.id, this.name, {this.email = '', this.createdAt});
  
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      json['id'] as String,
      json['name'] as String,
      email: json['email'] as String? ?? '',
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
    };
  }
  
  User copyWith({
    String? id,
    String? name,
    String? email,
    DateTime? createdAt,
  }) {
    return User(
      id ?? this.id,
      name ?? this.name,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
    );
  }
  
  @override
  String toString() => 'User(id: $id, name: $name, email: $email)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }
  
  @override
  int get hashCode => id.hashCode;
}
```

### 10.2 WebSocket e Real-time Communication

```dart
import 'dart:convert';
import 'dart:io';

class WebSocketManager {
  WebSocket? _webSocket;
  final String url;
  final Duration reconnectInterval;
  final int maxReconnectAttempts;
  
  late StreamController<dynamic> _messageController;
  late StreamController<WebSocketState> _stateController;
  
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;
  bool _isDisposed = false;
  
  WebSocketManager({
    required this.url,
    this.reconnectInterval = const Duration(seconds: 5),
    this.maxReconnectAttempts = 5,
  }) {
    _messageController = StreamController<dynamic>.broadcast();
    _stateController = StreamController<WebSocketState>.broadcast();
  }
  
  Stream<dynamic> get messages => _messageController.stream;
  Stream<WebSocketState> get state => _stateController.stream;
  
  WebSocketState get currentState {
    if (_webSocket == null) return WebSocketState.disconnected;
    
    switch (_webSocket!.readyState) {
      case WebSocket.connecting:
        return WebSocketState.connecting;
      case WebSocket.open:
        return WebSocketState.connected;
      case WebSocket.closing:
        return WebSocketState.disconnecting;
      case WebSocket.closed:
        return WebSocketState.disconnected;
      default:
        return WebSocketState.disconnected;
    }
  }
  
  Future<void> connect() async {
    if (_isDisposed) return;
    
    try {
      _stateController.add(WebSocketState.connecting);
      
      _webSocket = await WebSocket.connect(url);
      _reconnectAttempts = 0;
      
      _stateController.add(WebSocketState.connected);
      
      _webSocket!.listen(
        _onMessage,
        onError: _onError,
        onDone: _onDone,
        cancelOnError: false,
      );
      
    } catch (e) {
      _stateController.add(WebSocketState.disconnected);
      _scheduleReconnect();
    }
  }
  
  void send(dynamic message) {
    if (currentState == WebSocketState.connected) {
      var jsonMessage = message is String ? message : jsonEncode(message);
      _webSocket!.add(jsonMessage);
    } else {
      throw StateError('WebSocket is not connected');
    }
  }
  
  void _onMessage(dynamic message) {
    try {
      var data = message is String ? jsonDecode(message) : message;
      _messageController.add(data);
    } catch (e) {
      _messageController.add(message);
    }
  }
  
  void _onError(dynamic error) {
    print('WebSocket error: $error');
    _scheduleReconnect();
  }
  
  void _onDone() {
    _stateController.add(WebSocketState.disconnected);
    _scheduleReconnect();
  }
  
  void _scheduleReconnect() {
    if (_isDisposed || _reconnectAttempts >= maxReconnectAttempts) {
      return;
    }
    
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(reconnectInterval, () {
      _reconnectAttempts++;
      connect();
    });
  }
  
  Future<void> disconnect() async {
    _reconnectTimer?.cancel();
    
    if (_webSocket != null) {
      _stateController.add(WebSocketState.disconnecting);
      await _webSocket!.close();
      _webSocket = null;
    }
    
    _stateController.add(WebSocketState.disconnected);
  }
  
  void dispose() {
    _isDisposed = true;
    _reconnectTimer?.cancel();
    disconnect();
    _messageController.close();
    _stateController.close();
  }
}

enum WebSocketState {
  disconnected,
  connecting,
  connected,
  disconnecting,
}

// Real-time Chat Example
class ChatManager {
  final WebSocketManager _webSocketManager;
  late StreamController<ChatMessage> _messageController;
  late StreamController<List<ChatUser>> _usersController;
  
  final List<ChatMessage> _messages = [];
  final List<ChatUser> _users = [];
  
  ChatManager(String serverUrl) 
      : _webSocketManager = WebSocketManager(url: serverUrl) {
    _messageController = StreamController<ChatMessage>.broadcast();
    _usersController = StreamController<List<ChatUser>>.broadcast();
    
    _setupMessageHandling();
  }
  
  Stream<ChatMessage> get messages => _messageController.stream;
  Stream<List<ChatUser>> get users => _usersController.stream;
  Stream<WebSocketState> get connectionState => _webSocketManager.state;
  
  List<ChatMessage> get messageHistory => List.unmodifiable(_messages);
  List<ChatUser> get userList => List.unmodifiable(_users);
  
  void _setupMessageHandling() {
    _webSocketManager.messages.listen((data) {
      if (data is Map<String, dynamic>) {
        switch (data['type']) {
          case 'message':
            _handleChatMessage(data);
            break;
          case 'user_joined':
            _handleUserJoined(data);
            break;
          case 'user_left':
            _handleUserLeft(data);
            break;
          case 'users_list':
            _handleUsersList(data);
            break;
        }
      }
    });
  }
  
  void _handleChatMessage(Map<String, dynamic> data) {
    var message = ChatMessage.fromJson(data);
    _messages.add(message);
    _messageController.add(message);
  }
  
  void _handleUserJoined(Map<String, dynamic> data) {
    var user = ChatUser.fromJson(data['user']);
    _users.add(user);
    _usersController.add(List.from(_users));
  }
  
  void _handleUserLeft(Map<String, dynamic> data) {
    var userId = data['userId'] as String;
    _users.removeWhere((user) => user.id == userId);
    _usersController.add(List.from(_users));
  }
  
  void _handleUsersList(Map<String, dynamic> data) {
    var userList = (data['users'] as List)
        .map((json) => ChatUser.fromJson(json))
        .toList();
    _users.clear();
    _users.addAll(userList);
    _usersController.add(List.from(_users));
  }
  
  Future<void> connect() async {
    await _webSocketManager.connect();
  }
  
  void sendMessage(String text, String userId) {
    _webSocketManager.send({
      'type': 'message',
      'text': text,
      'userId': userId,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
  
  void joinRoom(String roomId, String userId, String username) {
    _webSocketManager.send({
      'type': 'join_room',
      'roomId': roomId,
      'userId': userId,
      'username': username,
    });
  }
  
  void leaveRoom(String roomId, String userId) {
    _webSocketManager.send({
      'type': 'leave_room',
      'roomId': roomId,
      'userId': userId,
    });
  }
  
  Future<void> disconnect() async {
    await _webSocketManager.disconnect();
  }
  
  void dispose() {
    _webSocketManager.dispose();
    _messageController.close();
    _usersController.close();
  }
}

class ChatMessage {
  final String id;
  final String text;
  final String userId;
  final String username;
  final DateTime timestamp;
  
  ChatMessage({
    required this.id,
    required this.text,
    required this.userId,
    required this.username,
    required this.timestamp,
  });
  
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      text: json['text'] as String,
      userId: json['userId'] as String,
      username: json['username'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'userId': userId,
      'username': username,
      'timestamp': timestamp.toIso8601String(),
    };
  }
  
  @override
  String toString() => '[$username]: $text';
}

class ChatUser {
  final String id;
  final String username;
  final bool isOnline;
  
  ChatUser({
    required this.id,
    required this.username,
    this.isOnline = true,
  });
  
  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      id: json['id'] as String,
      username: json['username'] as String,
      isOnline: json['isOnline'] as bool? ?? true,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'isOnline': isOnline,
    };
  }
  
  @override
  String toString() => username;
}
```

## 11. Desenvolvimento de Packages e Bibliotecas

### 11.1 Estrutura de Package

```dart
// pubspec.yaml structure exemplo:
/*
name: my_awesome_package
description: An awesome Dart package that does amazing things.
version: 1.0.0
homepage: https://github.com/user/my_awesome_package

environment:
  sdk: '>=2.18.0 <4.0.0'

dependencies:
  meta: ^1.8.0

dev_dependencies:
  test: ^1.21.0
  lints: ^2.0.0

topics:
  - utilities
  - helper
  - tools
*/

// lib/my_awesome_package.dart - Main export file
library my_awesome_package;

export 'src/core/awesome_class.dart';
export 'src/utilities/helper_functions.dart';
export 'src/models/data_models.dart';

// Conditional exports for different platforms
export 'src/io_implementation.dart' if (dart.library.html) 'src/web_implementation.dart';

// lib/src/core/awesome_class.dart
import 'package:meta/meta.dart';

/// Uma classe incrível que demonstra boas práticas de desenvolvimento.
/// 
/// Esta classe serve como exemplo de como estruturar código em packages,
/// incluindo documentação, testes e versionamento semântico.
/// 
/// Exemplo de uso:
/// ```dart
/// var awesome = AwesomeClass('Hello');
/// print(awesome.process()); // Hello - processed
/// ```
@immutable
class AwesomeClass {
  /// O valor base que será processado.
  final String value;
  
  /// Cria uma instância de [AwesomeClass] com o [value] fornecido.
  /// 
  /// O [value] não pode ser vazio.
  /// 
  /// Throws [ArgumentError] se [value] estiver vazio.
  const AwesomeClass(this.value) : assert(value != '', 'Value cannot be empty');
  
  /// Processa o valor e retorna uma string formatada.
  /// 
  /// Este método adiciona um sufixo " - processed" ao valor original.
  /// 
  /// Returns: Uma string contendo o valor original seguido de " - processed".
  String process() {
    return '$value - processed';
  }
  
  /// Processa o valor de forma assíncrona.
  /// 
  /// Simula uma operação que demora um tempo para completar.
  /// 
  /// [delay] especifica quanto tempo aguardar antes de processar.
  /// 
  /// Returns: Um [Future] que resolve para a string processada.
  Future<String> processAsync({Duration delay = const Duration(milliseconds: 100)}) async {
    await Future.delayed(delay);
    return process();
  }
  
  /// Processa múltiplos valores em batch.
  /// 
  /// [values] é uma lista de strings para processar.
  /// [batchSize] especifica quantos itens processar por vez.
  /// 
  /// Returns: Um [Stream] de strings processadas.
  Stream<String> processBatch(
    List<String> values, {
    int batchSize = 10,
  }) async* {
    for (int i = 0; i < values.length; i += batchSize) {
      var batch = values.skip(i).take(batchSize);
      for (var value in batch) {
        var processor = AwesomeClass(value);
        yield await processor.processAsync();
      }
    }
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AwesomeClass && other.value == value;
  }
  
  @override
  int get hashCode => value.hashCode;
  
  @override
  String toString() => 'AwesomeClass(value: $value)';
}

// lib/src/utilities/helper_functions.dart

/// Utilitários para manipulação de strings.
class StringUtils {
  StringUtils._(); // Private constructor para classe utilitária
  
  /// Converte uma string para title case.
  /// 
  /// Exemplo: "hello world" -> "Hello World"
  static String toTitleCase(String input) {
    if (input.isEmpty) return input;
    
    return input
        .split(' ')
        .map((word) => word.isEmpty 
            ? word 
            : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}')
        .join(' ');
  }
  
  /// Remove acentos de uma string.
  /// 
  /// Exemplo: "João" -> "Joao"
  static String removeAccents(String input) {
    const accents = {
      'á': 'a', 'à': 'a', 'ã': 'a', 'â': 'a', 'ä': 'a',
      'é': 'e', 'è': 'e', 'ê': 'e', 'ë': 'e',
      'í': 'i', 'ì': 'i', 'î': 'i', 'ï': 'i',
      'ó': 'o', 'ò': 'o', 'õ': 'o', 'ô': 'o', 'ö': 'o',
      'ú': 'u', 'ù': 'u', 'û': 'u', 'ü': 'u',
      'ç': 'c', 'ñ': 'n',
      // Maiúsculas
      'Á': 'A', 'À': 'A', 'Ã': 'A', 'Â': 'A', 'Ä': 'A',
      'É': 'E', 'È': 'E', 'Ê': 'E', 'Ë': 'E',
      'Í': 'I', 'Ì': 'I', 'Î': 'I', 'Ï': 'I',
      'Ó': 'O', 'Ò': 'O', 'Õ': 'O', 'Ô': 'O', 'Ö': 'O',
      'Ú': 'U', 'Ù': 'U', 'Û': 'U', 'Ü': 'U',
      'Ç': 'C', 'Ñ': 'N',
    };
    
    var result = input;
    accents.forEach((accented, plain) {
      result = result.replaceAll(accented, plain);
    });
    
    return result;
  }
  
  /// Trunca uma string para um comprimento máximo.
  /// 
  /// [maxLength] o comprimento máximo permitido.
  /// [ellipsis] o que adicionar no final se a string for truncada.
  static String truncate(String input, int maxLength, {String ellipsis = '...'}) {
    if (input.length <= maxLength) return input;
    
    var truncateLength = maxLength - ellipsis.length;
    if (truncateLength <= 0) return ellipsis.substring(0, maxLength);
    
    return '${input.substring(0, truncateLength)}$ellipsis';
  }
  
  /// Conta palavras em uma string.
  static int wordCount(String input) {
    return input.trim().isEmpty 
        ? 0 
        : input.trim().split(RegExp(r'\s+')).length;
  }
}

/// Utilitários para validação.
class ValidationUtils {
  ValidationUtils._();
  
  /// Valida se uma string é um email válido.
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,},
    );
    return emailRegex.hasMatch(email);
  }
  
  /// Valida se uma string é um CPF válido.
  static bool isValidCPF(String cpf) {
    // Remove formatação
    var cleanCPF = cpf.replaceAll(RegExp(r'[^\d]'), '');
    
    // Verifica se tem 11 dígitos
    if (cleanCPF.length != 11) return false;
    
    // Verifica se não são todos iguais (ex: 111.111.111-11)
    if (RegExp(r'^(\d)\1{10}).hasMatch(cleanCPF)) return false;
    
    // Calcula primeiro dígito verificador
    var sum = 0;
    for (int i = 0; i < 9; i++) {
      sum += int.parse(cleanCPF[i]) * (10 - i);
    }
    var firstDigit = 11 - (sum % 11);
    if (firstDigit >= 10) firstDigit = 0;
    
    // Calcula segundo dígito verificador
    sum = 0;
    for (int i = 0; i < 10; i++) {
      sum += int.parse(cleanCPF[i]) * (11 - i);
    }
    var secondDigit = 11 - (sum % 11);
    if (secondDigit >= 10) secondDigit = 0;
    
    // Verifica se os dígitos calculados coincidem com os informados
    return int.parse(cleanCPF[9]) == firstDigit && 
           int.parse(cleanCPF[10]) == secondDigit;
  }
  
  /// Valida se uma string é um URL válido.
  static bool isValidUrl(String url) {
    try {
      var uri = Uri.parse(url);
      return uri.hasScheme && uri.hasAuthority;
    } catch (e) {
      return false;
    }
  }
  
  /// Valida força de senha.
  /// 
  /// Returns um [PasswordStrength] indicando a força da senha.
  static PasswordStrength getPasswordStrength(String password) {
    if (password.length < 6) return PasswordStrength.weak;
    
    var hasUpper = password.contains(RegExp(r'[A-Z]'));
    var hasLower = password.contains(RegExp(r'[a-z]'));
    var hasDigit = password.contains(RegExp(r'[0-9]'));
    var hasSpecial = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    
    var criteriaCount = [hasUpper, hasLower, hasDigit, hasSpecial]
        .where((criteria) => criteria)
        .length;
    
    if (password.length >= 12 && criteriaCount >= 3) {
      return PasswordStrength.strong;
    } else if (password.length >= 8 && criteriaCount >= 2) {
      return PasswordStrength.medium;
    } else {
      return PasswordStrength.weak;
    }
  }
}

enum PasswordStrength {
  weak,
  medium,
  strong,
}

// lib/src/models/data_models.dart

/// Modelo base para objetos que possuem ID.
abstract class Identifiable {
  String get id;
}

/// Modelo base para objetos com timestamp.
abstract class Timestamped {
  DateTime get createdAt;
  DateTime? get updatedAt;
}

/// Modelo de resposta paginada.
/// 
/// Usado para representar respostas de API que retornam dados paginados.
class PaginatedResponse<T> {
  /// Os itens da página atual.
  final List<T> items;
  
  /// Número total de itens disponíveis.
  final int totalCount;
  
  /// Número da página atual (baseado em 1).
  final int currentPage;
  
  /// Número total de páginas.
  final int totalPages;
  
  /// Número de itens por página.
  final int pageSize;
  
  /// Se existe uma próxima página.
  final bool hasNext;
  
  /// Se existe uma página anterior.
  final bool hasPrevious;
  
  const PaginatedResponse({
    required this.items,
    required this.totalCount,
    required this.currentPage,
    required this.totalPages,
    required this.pageSize,
    required this.hasNext,
    required this.hasPrevious,
  });
  
  /// Cria uma instância de [PaginatedResponse] calculando automaticamente
  /// os campos derivados.
  factory PaginatedResponse.create({
    required List<T> items,
    required int totalCount,
    required int currentPage,
    required int pageSize,
  }) {
    var totalPages = (totalCount / pageSize).ceil();
    
    return PaginatedResponse(
      items: items,
      totalCount: totalCount,
      currentPage: currentPage,
      totalPages: totalPages,
      pageSize: pageSize,
      hasNext: currentPage < totalPages,
      hasPrevious: currentPage > 1,
    );
  }
  
  /// Converte para JSON.
  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) itemToJson) {
    return {
      'items': items.map(itemToJson).toList(),
      'totalCount': totalCount,
      'currentPage': currentPage,
      'totalPages': totalPages,
      'pageSize': pageSize,
      'hasNext': hasNext,
      'hasPrevious': hasPrevious,
    };
  }
  
  /// Cria uma instância a partir de JSON.
  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) itemFromJson,
  ) {
    return PaginatedResponse(
      items: (json['items'] as List)
          .map((item) => itemFromJson(item as Map<String, dynamic>))
          .toList(),
      totalCount: json['totalCount'] as int,
      currentPage: json['currentPage'] as int,
      totalPages: json['totalPages'] as int,
      pageSize: json['pageSize'] as int,
      hasNext: json['hasNext'] as bool,
      hasPrevious: json['hasPrevious'] as bool,
    );
  }
  
  @override
  String toString() {
    return 'PaginatedResponse(page: $currentPage/$totalPages, items: ${items.length}/$totalCount)';
  }
}

/// Configuração de cache.
class CacheConfig {
  /// Duração padrão do cache.
  final Duration defaultTtl;
  
  /// Tamanho máximo do cache em número de entradas.
  final int maxSize;
  
  /// Se deve fazer cleanup automático de entradas expiradas.
  final bool autoCleanup;
  
  /// Intervalo do cleanup automático.
  final Duration cleanupInterval;
  
  const CacheConfig({
    this.defaultTtl = const Duration(minutes: 30),
    this.maxSize = 1000,
    this.autoCleanup = true,
    this.cleanupInterval = const Duration(minutes: 5),
  });
}

// lib/src/cache/memory_cache.dart

/// Cache em memória com TTL e LRU eviction.
class MemoryCache<K, V> {
  final CacheConfig _config;
  final Map<K, _CacheEntry<V>> _cache = {};
  final LinkedList<_CacheNode<K>> _accessOrder = LinkedList<_CacheNode<K>>();
  Timer? _cleanupTimer;
  
  MemoryCache([CacheConfig? config]) : _config = config ?? const CacheConfig() {
    if (_config.autoCleanup) {
      _startCleanupTimer();
    }
  }
  
  /// Obtém um valor do cache.
  /// 
  /// Returns o valor se estiver presente e não expirado, caso contrário null.
  V? get(K key) {
    var entry = _cache[key];
    if (entry == null || entry.isExpired) {
      if (entry != null) {
        _removeEntry(key);
      }
      return null;
    }
    
    _updateAccessOrder(key);
    return entry.value;
  }
  
  /// Adiciona um valor ao cache.
  /// 
  /// [ttl] especifica o time-to-live para esta entrada específica.
  /// Se não fornecido, usa o TTL padrão da configuração.
  void put(K key, V value, {Duration? ttl}) {
    // Remove entrada existente se houver
    if (_cache.containsKey(key)) {
      _removeEntry(key);
    }
    
    // Verifica se precisa fazer eviction
    if (_cache.length >= _config.maxSize) {
      _evictLeastRecentlyUsed();
    }
    
    var expirationTime = DateTime.now().add(ttl ?? _config.defaultTtl);
    _cache[key] = _CacheEntry(value, expirationTime);
    _updateAccessOrder(key);
  }
  
  /// Remove uma entrada do cache.
  bool remove(K key) {
    return _removeEntry(key);
  }
  
  /// Limpa todo o cache.
  void clear() {
    _cache.clear();
    _accessOrder.clear();
  }
  
  /// Retorna o número de entradas no cache.
  int get size => _cache.length;
  
  /// Verifica se o cache está vazio.
  bool get isEmpty => _cache.isEmpty;
  
  /// Verifica se o cache contém uma chave.
  bool containsKey(K key) {
    var entry = _cache[key];
    if (entry == null || entry.isExpired) {
      if (entry != null) {
        _removeEntry(key);
      }
      return false;
    }
    return true;
  }
  
  /// Remove entradas expiradas manualmente.
  void cleanup() {
    var expiredKeys = <K>[];
    
    _cache.forEach((key, entry) {
      if (entry.isExpired) {
        expiredKeys.add(key);
      }
    });
    
    for (var key in expiredKeys) {
      _removeEntry(key);
    }
  }
  
  /// Obtém estatísticas do cache.
  CacheStats getStats() {
    var expiredCount = _cache.values.where((entry) => entry.isExpired).length;
    
    return CacheStats(
      totalEntries: _cache.length,
      expiredEntries: expiredCount,
      activeEntries: _cache.length - expiredCount,
      maxSize: _config.maxSize,
    );
  }
  
  void _updateAccessOrder(K key) {
    // Remove da posição atual se existir
    _accessOrder.where((node) => node.key == key).forEach((node) => node.unlink());
    
    // Adiciona no final (mais recente)
    _accessOrder.add(_CacheNode(key));
  }
  
  bool _removeEntry(K key) {
    var removed = _cache.remove(key) != null;
    if (removed) {
      _accessOrder.where((node) => node.key == key).forEach((node) => node.unlink());
    }
    return removed;
  }
  
  void _evictLeastRecentlyUsed() {
    if (_accessOrder.isNotEmpty) {
      var lruKey = _accessOrder.first.key;
      _removeEntry(lruKey);
    }
  }
  
  void _startCleanupTimer() {
    _cleanupTimer = Timer.periodic(_config.cleanupInterval, (_) {
      cleanup();
    });
  }
  
  /// Dispose do cache, cancelando timers e limpando dados.
  void dispose() {
    _cleanupTimer?.cancel();
    clear();
  }
}

class _CacheEntry<V> {
  final V value;
  final DateTime expirationTime;
  
  _CacheEntry(this.value, this.expirationTime);
  
  bool get isExpired => DateTime.now().isAfter(expirationTime);
}

class _CacheNode<K> extends LinkedListEntry<_CacheNode<K>> {
  final K key;
  
  _CacheNode(this.key);
}

/// Estatísticas do cache.
class CacheStats {
  final int totalEntries;
  final int expiredEntries;
  final int activeEntries;
  final int maxSize;
  
  const CacheStats({
    required this.totalEntries,
    required this.expiredEntries,
    required this.activeEntries,
    required this.maxSize,
  });
  
  double get hitRatio {
    return totalEntries > 0 ? activeEntries / totalEntries : 0.0;
  }
  
  double get fillRatio {
    return maxSize > 0 ? totalEntries / maxSize : 0.0;
  }
  
  @override
  String toString() {
    return 'CacheStats(total: $totalEntries, active: $activeEntries, '
           'expired: $expiredEntries, hit ratio: ${(hitRatio * 100).toStringAsFixed(1)}%, '
           'fill ratio: ${(fillRatio * 100).toStringAsFixed(1)}%)';
  }
}
```

### 11.2 Testing do Package

```dart
// test/awesome_class_test.dart
import 'package:test/test.dart';
import 'package:my_awesome_package/my_awesome_package.dart';

void main() {
  group('AwesomeClass', () {
    test('should create instance with valid value', () {
      var awesome = AwesomeClass('test');
      expect(awesome.value, equals('test'));
    });
    
    test('should throw assertion error for empty value', () {
      expect(() => AwesomeClass(''), throwsA(isA<AssertionError>()));
    });
    
    test('should process value correctly', () {
      var awesome = AwesomeClass('hello');
      expect(awesome.process(), equals('hello - processed'));
    });
    
    test('should process value asynchronously', () async {
      var awesome = AwesomeClass('async');
      var result = await awesome.processAsync();
      expect(result, equals('async - processed'));
    });
    
    test('should process batch of values', () async {
      var awesome = AwesomeClass('batch');
      var values = ['item1', 'item2', 'item3'];
      
      var results = <String>[];
      await for (var result in awesome.processBatch(values)) {
        results.add(result);
      }
      
      expect(results, hasLength(3));
      expect(results[0], equals('item1 - processed'));
      expect(results[1], equals('item2 - processed'));
      expect(results[2], equals('item3 - processed'));
    });
    
    test('should handle equality correctly', () {
      var awesome1 = AwesomeClass('test');
      var awesome2 = AwesomeClass('test');
      var awesome3 = AwesomeClass('different');
      
      expect(awesome1, equals(awesome2));
      expect(awesome1, isNot(equals(awesome3)));
    });
    
    test('should have consistent hashCode', () {
      var awesome1 = AwesomeClass('test');
      var awesome2 = AwesomeClass('test');
      
      expect(awesome1.hashCode, equals(awesome2.hashCode));
    });
  });
  
  group('StringUtils', () {
    test('should convert to title case', () {
      expect(StringUtils.toTitleCase('hello world'), equals('Hello World'));
      expect(StringUtils.toTitleCase('HELLO WORLD'), equals('Hello World'));
      expect(StringUtils.toTitleCase(''), equals(''));
    });
    
    test('should remove accents', () {
      expect(StringUtils.removeAccents('João'), equals('Joao'));
      expect(StringUtils.removeAccents('São Paulo'), equals('Sao Paulo'));
      expect(StringUtils.removeAccents('Coração'), equals('Coracao'));
    });
    
    test('should truncate strings correctly', () {
      expect(StringUtils.truncate('Hello World', 5), equals('He...'));
      expect(StringUtils.truncate('Hi', 10), equals('Hi'));
      expect(StringUtils.truncate('Test', 4), equals('Test'));
    });
    
    test('should count words correctly', () {
      expect(StringUtils.wordCount('Hello world'), equals(2));
      expect(StringUtils.wordCount(''), equals(0));
      expect(StringUtils.wordCount('   '), equals(0));
      expect(StringUtils.wordCount('One'), equals(1));
    });
  });
  
  group('ValidationUtils', () {
    test('should validate email addresses', () {
      expect(ValidationUtils.isValidEmail('test@example.com'), isTrue);
      expect(ValidationUtils.isValidEmail('invalid-email'), isFalse);
      expect(ValidationUtils.isValidEmail('test@'), isFalse);
      expect(ValidationUtils.isValidEmail('@example.com'), isFalse);
    });
    
    test('should validate CPF', () {
      expect(ValidationUtils.isValidCPF('123.456.789-09'), isTrue);
      expect(ValidationUtils.isValidCPF('12345678909'), isTrue);
      expect(ValidationUtils.isValidCPF('111.111.111-11'), isFalse);
      expect(ValidationUtils.isValidCPF('123.456.789-00'), isFalse);
    });
    
    test('should validate URLs', () {
      expect(ValidationUtils.isValidUrl('https://example.com'), isTrue);
      expect(ValidationUtils.isValidUrl('http://test.org'), isTrue);
      expect(ValidationUtils.isValidUrl('not-a-url'), isFalse);
      expect(ValidationUtils.isValidUrl('ftp://example.com'), isTrue);
    });
    
    test('should evaluate password strength', () {
      expect(ValidationUtils.getPasswordStrength('123'), equals(PasswordStrength.weak));
      expect(ValidationUtils.getPasswordStrength('Password1'), equals(PasswordStrength.medium));
      expect(ValidationUtils.getPasswordStrength('StrongP@ssw0rd!'), equals(PasswordStrength.strong));
    });
  });
  
  group('MemoryCache', () {
    late MemoryCache<String, String> cache;
    
    setUp(() {
      cache = MemoryCache<String, String>(
        CacheConfig(
          defaultTtl: Duration(milliseconds: 100),
          maxSize: 3,
          autoCleanup: false,
        ),
      );
    });
    
    tearDown(() {
      cache.dispose();
    });
    
    test('should store and retrieve values', () {
      cache.put('key1', 'value1');
      expect(cache.get('key1'), equals('value1'));
      expect(cache.size, equals(1));
    });
    
    test('should return null for non-existent keys', () {
      expect(cache.get('non-existent'), isNull);
    });
    
    test('should handle expiration', () async {
      cache.put('key1', 'value1');
      expect(cache.get('key1'), equals('value1'));
      
      await Future.delayed(Duration(milliseconds: 150));
      expect(cache.get('key1'), isNull);
    });
    
    test('should evict least recently used items', () {
      cache.put('key1', 'value1');
      cache.put('key2', 'value2');
      cache.put('key3', 'value3');
      
      // Access key1 to make it recently used
      cache.get('key1');
      
      // Add key4, should evict key2 (least recently used)
      cache.put('key4', 'value4');
      
      expect(cache.get('key1'), equals('value1'));
      expect(cache.get('key2'), isNull);
      expect(cache.get('key3'), equals('value3'));
      expect(cache.get('key4'), equals('value4'));
    });
    
    test('should remove entries', () {
      cache.put('key1', 'value1');
      expect(cache.remove('key1'), isTrue);
      expect(cache.get('key1'), isNull);
      expect(cache.remove('non-existent'), isFalse);
    });
    
    test('should clear all entries', () {
      cache.put('key1', 'value1');
      cache.put('key2', 'value2');
      
      cache.clear();
      
      expect(cache.size, equals(0));
      expect(cache.isEmpty, isTrue);
    });
    
    test('should provide accurate statistics', () {
      cache.put('key1', 'value1');
      cache.put('key2', 'value2');
      
      var stats = cache.getStats();
      expect(stats.totalEntries, equals(2));
      expect(stats.activeEntries, equals(2));
      expect(stats.expiredEntries, equals(0));
    });
  });
  
  group('PaginatedResponse', () {
    test('should create instance with calculated fields', () {
      var response = PaginatedResponse<String>.create(
        items: ['item1', 'item2'],
        totalCount: 10,
        currentPage: 2,
        pageSize: 5,
      );
      
      expect(response.items.length, equals(2));
      expect(response.totalPages, equals(2));
      expect(response.hasNext, isFalse);
      expect(response.hasPrevious, isTrue);
    });
    
    test('should serialize to and from JSON', () {
      var original = PaginatedResponse<Map<String, dynamic>>.create(
        items: [{'id': 1, 'name': 'Test'}],
        totalCount: 1,
        currentPage: 1,
        pageSize: 10,
      );
      
      var json = original.toJson((item) => item);
      var restored = PaginatedResponse<Map<String, dynamic>>.fromJson(
        json,
        (json) => json,
      );
      
      expect(restored.items.length, equals(original.items.length));
      expect(restored.totalCount, equals(original.totalCount));
      expect(restored.currentPage, equals(original.currentPage));
    });
  });
}

// test/integration_test.dart
import 'package:test/test.dart';
import 'package:my_awesome_package/my_awesome_package.dart';

void main() {
  group('Integration Tests', () {
    test('should work with real-world scenario', () async {
      // Simula um cenário real usando múltiplas classes do package
      var cache = MemoryCache<String, String>();
      
      // Processa alguns valores
      var processor = AwesomeClass('integration test');
      var processedValue = await processor.processAsync();
      
      // Armazena no cache
      cache.put('processed', processedValue);
      
      // Valida email
      var isValidEmail = ValidationUtils.isValidEmail('test@example.com');
      
      // Manipula string
      var titleCase = StringUtils.toTitleCase(processedValue);
      
      // Verifica se tudo funcionou junto
      expect(cache.get('processed'), equals('integration test - processed'));
      expect(isValidEmail, isTrue);
      expect(titleCase, equals('Integration Test - Processed'));
      
      cache.dispose();
    });
    
    test('should handle batch processing with cache', () async {
      var cache = MemoryCache<String, List<String>>();
      var processor = AwesomeClass('batch');
      
      var inputValues = ['item1', 'item2', 'item3'];
      var results = <String>[];
      
      await for (var result in processor.processBatch(inputValues, batchSize: 2)) {
        results.add(result);
      }
      
      cache.put('batch_results', results);
      
      var cachedResults = cache.get('batch_results');
      expect(cachedResults, isNotNull);
      expect(cachedResults!.length, equals(3));
      expect(cachedResults.every((r) => r.endsWith(' - processed')), isTrue);
      
      cache.dispose();
    });
  });
}
```

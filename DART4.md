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

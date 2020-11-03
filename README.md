- [SDOSAlamofire+JSONAPI](#sdosalamofirejsonapi)
  - [Introducción](#introducción)
  - [Instalación](#instalación)
    - [Cocoapods](#cocoapods)
    - [Swift Package Manager](#swift-package-manager)
      - [**En el "Project"**](#en-el-project)
      - [**En un Package.swift**](#en-un-packageswift)
  - [ResponseSerializer](#responseserializer)
    - [SDOSJSONAPIResponseSerializer](#sdosjsonapiresponseserializer)
    - [Modelos](#modelos)
    - [Ejemplo](#ejemplo)
  - [Dependencias](#dependencias)

# SDOSAlamofire+JSONAPI

- Para consultar los últimos cambios en la librería consultar el [CHANGELOG.md](https://github.com/SDOSLabs/SDOSAlamofireJSONAPI/blob/master/CHANGELOG.md).

- Enlace confluence: https://kc.sdos.es/x/jgtyAg

## Introducción

Con SDOSAlamofire podemos integrar un serializer para el parseo de las respuestas de los servicios web con una estructura [JSON:API](https://jsonapi.org).

## Instalación

### Cocoapods

Usaremos [CocoaPods](https://cocoapods.org). Hay que añadir la dependencia al `Podfile`:

```ruby
pod 'SDOSAlamofireJSONAPI', '~>1.0.0' 
pod 'Japx/Codable', :tag => '3.1.0', :git => 'https://github.com/SDOSLabs/Japx.git'
```

### Swift Package Manager

A partir de Xcode 12 podemos incluir esta librería a través de Swift package Manager. Existen 2 formas de añadirla a un proyecto:

#### **En el "Project"**

Debemos abrir nuestro proyecto en Xcode y seleccionar el proyecto para abrir su configuración. Una vez aquí seleccionar la pestaña "Swift Packages" y añadir el siguiente repositorio

```
https://github.com/SDOSLabs/SDOSAlamofireJSONAPI.git
```

En el siguiente paso deberemos seleccionar la versión que queremos instalar. Recomentamos indicar "Up to Next Major" `1.0.0`.

Por último deberemos indicar el o los targets donde se deberá incluir la librería

#### **En un Package.swift**

Incluir la dependencia en el bloque `dependencies`:

``` swift
dependencies: [
    .package(url: "https://github.com/SDOSLabs/SDOSAlamofireJSONAPI.git", .upToNextMajor(from: "1.0.0"))
]
```

Incluir la librería en el o los targets desados:

```js
.target(
    name: "YourDependency",
    dependencies: [
        "SDOSAlamofireJSONAPI"
    ]
)
```

## ResponseSerializer

### SDOSJSONAPIResponseSerializer

**`SDOSJSONAPIResponseSerializer`**: es el serializador que se usará para parsear los servicios que vengan con estructura JSONAPI.

```js
public class SDOSJSONAPIResponseSerializer<R: Decodable, E: AbstractErrorDTO>: ResponseSerializer {
    public init(includeList: String? = nil, keyPath: String? = JSONAPI.rootPath)
}
    
* Parámetros:
    * `includeList`: Lista de includes para la deserialización de relaciones de JSON:API.
    * `keyPath`: Raiz del JSON para su decodificación.
```

### Modelos

Los modelos de datos son iguales que los modelos que usamos para **`SDOSJSONResponseSerializer`**:

```js
public struct RouteDTO: GenericDTO {
    var type: String?
    var id: String?
    var title: String?
    var body: String?
    var category: CategoryDTO? //Include
    
    mutating public func map(map: KeyMap) throws {
        try type <-> map["type"]
        try id <-> map["id"]
        try title <-> map["title"]
        try body <-> map["body.value"]
        try category <<- map["field_route_category"]
    }
    
    public init(from decoder: Decoder) throws {
        try KeyedDecoder(with: decoder).decode(to: &self)
    }
}

struct CategoryDTO: GenericDTO {
    var type: String?
    var id: String?
    var name: String?
    
    mutating func map(map: KeyMap) throws {
        try type <-> map["type"]
        try id <-> map["id"]
        try name <-> map["name"]
    }
    
    init(from decoder: Decoder) throws {
        try KeyedDecoder(with: decoder).decode(to: &self)
    }
}
```

### Ejemplo

La forma de usar **`SDOSJSONAPIResponseSerializer`** es similar a **`SDOSJSONResponseSerializer`**:

```js
fileprivate lazy var session = GenericSession()

func loadRoutes() -> RequestValue<Promise<[RouteBO]>> {

    var url = "https://staging-costa-turismo.sdos-dev.tech/es/jsonapi/node/scity_route?sort=title&page[offset]=0&page[limit]=1&include=field_route_category"
    let responseSerializer = SDOSJSONAPIResponseSerializer<[RouteDTO], ErrorDTO>()
    let request = session.request(url, method: .get, parameters: nil)

    let promise = Promise<[RouteBO]> { seal in
        request.validate().responseJSONAPI(responseSerializer: responseSerializer) {
            (dataResponse: DataResponse<[RouteDTO]>) in
            switch dataResponse.result {
            case .success(let routesList):
                seal.fulfill(routesList)
            case .failure(let error as AFError):
                switch error {
                case .explicitlyCancelled, .sessionDeinitialized:
                    seal.reject(PMKError.cancelled)
                default:
                    seal.reject(error)
                }
            case .failure(let error):
                seal.reject(error)
            }
        }
        }.map { items -> [RouteBO] in
            items
    }

    return RequestValue(request: request, value: promise)
}
```

## Dependencias

* [SDOSAlamofire](https://github.com/SDOSLabs/SDOSAlamofire)
* [Japx/Codable](https://github.com/SDOSLabs/Japx.git) 3.1.0

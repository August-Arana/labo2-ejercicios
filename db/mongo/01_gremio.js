// Runs once when the Mongo volume is created (docker-entrypoint-initdb.d).
// Re-run any time with: lab mongo db/mongo/01_gremio.js
db = db.getSiblingDB("labo2");
db.aventureros.drop();
db.aventureros.insertMany([
  { _id: 100, nombre: "Aldric", apodo: "El Inquebrantable", raza: "HUMANO", nivel: 20,
    clase: { nombre: "PALADIN", dado_golpe: 10 },
    gremio: { nombre: "Escudos de Hierro", ciudad: "Puerto Ceniza" },
    oro: 15000, inventario: ["Armadura de placas del Alba", "Espada larga"],
    misiones: [ { titulo: "Rescatar al herrero secuestrado", rol: "LIDER", estado: "COMPLETADA" } ] },
  { _id: 106, nombre: "Seraphine", apodo: "La Docta", raza: "ELFA", nivel: 19,
    clase: { nombre: "MAGO", dado_golpe: 6 },
    gremio: { nombre: "La Llama Errante", ciudad: "Valdoria" },
    oro: 22000, inventario: ["Baston del Archimago", "Pergamino de bola de fuego", "Pocion de curacion"],
    hechizos: ["Bola de fuego", "Escudo arcano", "Teletransporte"],
    misiones: [ { titulo: "Negociar con los trolls del puente", rol: "LIDER", estado: "COMPLETADA" },
                { titulo: "Descifrar el pergamino maldito", rol: "LIDER", estado: "ABIERTA" } ] },
  { _id: 112, nombre: "Vex", apodo: "Sin Rostro", raza: "TIEFLING", nivel: 17,
    clase: { nombre: "PICARO", dado_golpe: 8 },
    gremio: { nombre: "Cofradia de la Sombra", ciudad: "Torre Umbria" },
    inventario: ["Daga envenenada", "Capa de sombras"],
    misiones: [ { titulo: "Cazar al nigromante de la torre", rol: "LIDER", estado: "FALLIDA" } ] },
  { _id: 123, nombre: "Wren", apodo: "La Errante", raza: "HUMANA", nivel: 7,
    clase: { nombre: "PICARO", dado_golpe: 8 },
    gremio: null, oro: 3300, inventario: [],
    misiones: [ { titulo: "Derrotar al dragon de Hondonada Gris", rol: "EXPLORADOR", estado: "COMPLETADA" } ] },
  { _id: 125, nombre: "Quill", apodo: "Tinta", raza: "GNOMO", nivel: 1,
    clase: { nombre: "BARDO", dado_golpe: 8 },
    gremio: { nombre: "La Llama Errante", ciudad: "Valdoria" },
    oro: 5, instrumento: "Laud desafinado", inventario: ["Pocion de curacion"], misiones: [] }
]);
print("labo2.aventureros: " + db.aventureros.countDocuments() + " documents");

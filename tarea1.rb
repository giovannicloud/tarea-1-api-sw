
require 'httparty'
require 'openssl'
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
URL = 'http://sepa.utem.cl/rest/api/v1'
AUTH = {username: '2E5Vw7WUCm', password: '0754e0cbf6df85c40be0715e643c9f1c'}

ASIGNATURAS = '/docencia/asignaturas'
DOCENTES = '/academia/docentes'

respuestasAsig = HTTParty.get(URL+ASIGNATURAS, basic_auth: AUTH)
respuestasDoc = HTTParty.get(URL+DOCENTES, basic_auth: AUTH)

inf = []
infAno = []
nomDoc = []

respuestasAsig.each do |asignatura|
	nombre = asignatura['departamento']['nombre']
	fecha = asignatura['fechaCreacion']
	if nombre == 'Informática y Computación'
		inf << asignatura['nombre']

		if fecha[0..3].to_i == 2015
			#puts fecha
			infAno << asignatura['nombre']
		end
	end
end

respuestasDoc.each do |docente|
	anoDoc = docente['fechaNacimiento']
	if anoDoc[0..3].to_i < 1980
		#puts anoDoc
		nomDoc << docente['nombres']+ " " +docente['apellidos']
	end
end

File.open('CarrascoAraya', 'w') do |f1|
	f1.puts'-----------------------------------------------------'
	f1.puts 'Asignaturas de INF : '
	f1.puts inf
	f1.puts'-----------------------------------------------------'
	f1.puts 'Asignaturas de INF impartidas el 2015 :'
	f1.puts infAno 
	f1.puts'-----------------------------------------------------'
	f1.puts 'Docentes nacido antes del 1980 : '
	f1.puts nomDoc
end

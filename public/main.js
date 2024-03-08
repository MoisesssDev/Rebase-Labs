function fetchData(callback) {
    var apiUrl = '/tests';
  
    fetch(apiUrl)
      .then(response => {
        if (!response.ok) {
          throw new Error('Erro na requisição: ' + response.statusText);
        }
        return response.json();
      })
      .then(data => callback(data))
      .catch(error => {
        console.error('Erro:', error);
      });
}
  
function generateTable(data) {
    if (!data) {
      return '<p>Falha ao carregar dados</p>';
    }
  
    var tableHeader = `
      <thead>
        <tr>
          <th>CPF</th>
          <th>Nome</th>
          <th>Email</th>
          <th>Data de Nascimento</th>
          <th>CRM do Médico</th>
          <th>Estado do CRM</th>
          <th>Nome do Médico</th>
          <th>Token do Resultado</th>
          <th>Data do Exame</th>
          <th>Exames</th>
        </tr>
      </thead>
    `;
  
    var tableBody = '<tbody>';

    data.forEach(item => {
        tableBody += `
        <tr>
            <td>${item.cpf || 'N/A'}</td>
            <td>${item.name || 'N/A'}</td>
            <td>${item.email || 'N/A'}</td>
            <td>${item.birthday || 'N/A'}</td>
            <td>${item.doctor ? item.doctor.crm || 'N/A' : 'N/A'}</td>
            <td>${item.doctor ? item.doctor.crm_state || 'N/A' : 'N/A'}</td>
            <td>${item.doctor ? item.doctor.name || 'N/A' : 'N/A'}</td>
            <td>${item.result_token || 'N/A'}</td>
            <td>${item.result_date || 'N/A'}</td>
            <td><a href="#" onclick="showDetails()">Detalhes</a></td>
        </tr>
        `;
    });

    tableBody += '</tbody>';

    var table = `<table>${tableHeader}${tableBody}</table>`;
    return table;
}
  
function showDetails() {
    console.log('Implemente a lógica para exibir detalhes dos exames aqui.');
}
  
document.addEventListener('DOMContentLoaded', function () {
    fetchData(function (data) {
        console.log(data);
        var tableHTML = generateTable(data);
        document.getElementById('table-container').innerHTML = tableHTML;
    });
});
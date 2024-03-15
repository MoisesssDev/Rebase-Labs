function fetchData(callback) {
    var apiUrl = '/api/v1/tests';
  
    fetch(apiUrl)
      .then(response => {
        if (!response.ok) {
          throw new Error('Erro na requisição: ' + response.statusText);
        }
        return response.json();
      })
      .then(data => callback(data))
}
  
function generateTableBody(data) {
  return data.map(item => `
    <tr>
      <td>${item.cpf}</td>
      <td>${item.name}</td>
      <td>${item.email}</td>
      <td>${item.birthday}</td>
      <td>${item.doctor.crm}</td>
      <td>${item.doctor.crm_state}</td>
      <td>${item.doctor.name}</td>
      <td>${item.result_token}</td>
      <td>${item.result_date}</td>
      <td><a href="/${item.result_token}">Detalhes</a></td>
    </tr>
  `).join('');
}
  
function renderTable(data) {
  if (data.length == 0) {
    msg_error = '<p style="text-align: center">Nenhum exame foi importado para o Rebase Labs.</p>';
    document.getElementById('table-container').innerHTML = msg_error
    console.log('Não existe resultados de exames.');
    return;
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

  var tableBody = `<tbody>${generateTableBody(data)}</tbody>`;
  var table = `<table>${tableHeader}${tableBody}</table>`;

  var tableContainer = document.getElementById('table-container');
  tableContainer.innerHTML = table;

  var searchInput = document.getElementById('search');
  searchInput.addEventListener('input', function () {
    filterTable(searchInput.value);
  });
}
  
function filterTable(filterText) {
  var tabelaExames = document.querySelector('table');
  var linhas = tabelaExames.querySelectorAll('tbody tr');

  linhas.forEach(function (linha) {
    var textoLinha = linha.innerText.toLowerCase();
    var filtroLowerCase = filterText.toLowerCase();
    linha.style.display = textoLinha.includes(filtroLowerCase) ? '' : 'none';
  });
}

function submitForm() {
  const formData = new FormData(document.getElementById('csv-form'));

  fetch('/api/v1/import_csv', {
    method: 'POST',
    body: formData
  })
  .then(response => {
    if (response.ok) {
      showMessage('(*) O arquivo CSV está sendo importado... Por favor, aguarde alguns instantes e atualize a página para ver os resultados');
    } else {
      showMessage('(*) Ocorreu um erro ao importar o arquivo CSV. Por favor, tente novamente.');
    }
  })
  .catch(error => {
    showMessage('(*) Ocorreu um erro ao importar o arquivo CSV. Por favor, tente novamente.');
    console.error('Erro:', error);
  });
}

function showMessage(message) {
  const messageContainer = document.getElementById('message-container');
  messageContainer.innerHTML = `<p>${message}</p>`;
}
  
document.addEventListener('DOMContentLoaded', function () {
  fetchData(function (data) {
    console.log(data);
    renderTable(data);
  });
});
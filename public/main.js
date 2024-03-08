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

    var title = '<h2><img src="images/note.png" alt="exames"> Resultado dos exames</h2>';
    var search = '<input type="text" id="search" placeholder="Pesquisar por token...">';
    var msg_welcome = '<p>&#128075; Bem-vindo ao Rebase Labs!</p>'
    var nav_table = `<div class="nav-table">${msg_welcome} <div class="nav-table-content">${title}${search}</div></div>`;
  
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

    var table = `${nav_table}<table>${tableHeader}${tableBody}</table>`;

    // Adicionar o ouvinte de eventos ao input de pesquisa
    var tableContainer = document.getElementById('table-container');
    tableContainer.innerHTML = table;

    var searchInput = document.getElementById('search');
    searchInput.addEventListener('input', function () {
        filterTable(searchInput.value);
    });

    // return table;
}

function filterTable(filterText) {
    // Obtém a referência para a tabela
    var tabelaExames = document.querySelector('table');
  
    // Obtém todas as linhas da tabela, excluindo a linha de cabeçalho
    var linhas = tabelaExames.querySelectorAll('tbody tr');
  
    // Itera sobre as linhas e mostra ou oculta com base no filtro
    linhas.forEach(function (linha) {
      var textoLinha = linha.innerText.toLowerCase();
      var filtroLowerCase = filterText.toLowerCase();
  
      // Se o texto da linha contiver o texto do filtro, mostra a linha, caso contrário, oculta
      linha.style.display = textoLinha.includes(filtroLowerCase) ? '' : 'none';
    });
}
  
function showDetails() {
    console.log('Implemente a lógica para exibir detalhes dos exames aqui.');
}
  
document.addEventListener('DOMContentLoaded', function () {
    fetchData(function (data) {
        console.log(data);
        // var tableHTML = generateTable(data);
        // document.getElementById('table-container').innerHTML = tableHTML;
        generateTable(data);
    });
});
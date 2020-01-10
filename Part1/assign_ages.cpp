#include <bits/stdc++.h>
#define all(a) a.begin(), a.end()
#define forn(i,n) for(int i = 0; i < (int) n; i++)
#define ios ios::sync_with_stdio(false); cin.tie(0); cout.tie(0)

using namespace std;

vector<vector<int>> adj;
vector<bool> seen;
vector<double> age;

unsigned seed = chrono::system_clock::now().time_since_epoch().count();
default_random_engine rnd(seed);
uniform_real_distribution<double> uniform(0.0, 1.0);

// agedist[i] = proportion of population that is less than 5*(i+1) years old
vector<double> agedist{0.0, 0.0, 0.068, 0.138, 0.211, 0.285, 0.359, 0.432, 0.508, 0.59, 0.676, 0.758, 0.827, 0.882, 0.923, 0.952, 0.974, 1.0};
double random_age() {
  double r = uniform(rnd);

  for (int i = 0; i < agedist.size(); i++)
    if (r <= agedist[i])
      return 5 * i + 5 * uniform(rnd);
}

int main() {
  freopen("age.txt", "w", stdout);
  freopen("graph.txt", "r", stdin);

  int n, m;
  cin >> n >> m;
//  cout << n << " " << m << "\n";

  seen.resize(n);
  adj.resize(n);
  age.resize(n);
  forn(i, m) {
    int a, b;
    cin >> a >> b;

    assert(a < n && b < n);
    adj[a].push_back(b);
    adj[b].push_back(a);
  }

  queue<int> q;
  forn(i, n / 20) {
    int r = uniform(rnd) * n;
    age[r] = random_age();
    q.push(r);
  }

  while(!q.empty()) {
    int u = q.front();
    q.pop();
    if (seen[u]) continue;
    seen[u] = 1;

    int nbrs = 0, sm = 0;
    for(int v : adj[u])
      if (age[v]) {
        nbrs++;
        sm += age[v];
      } else
        q.push(v);

    if (nbrs && uniform(rnd) < 0.1 + nbrs * 0.009) {
      // friends have similar ages
      normal_distribution<double> distribution(1.0 * sm / nbrs, 5);
      age[u] = distribution(rnd);
    } else
      age[u] = random_age();
  }

  forn(i, n) cout << age[i] - 5 << "\n";
}

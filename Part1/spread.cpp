#include <bits/stdc++.h>
#define all(a) a.begin(), a.end()
#define forn(i,n) for(int i = 0; i < (int) n; i++)

using namespace std;

vector<vector<int>> adj;
vector<double> age;
int n;
vector<bool> addicted;

unsigned seed = chrono::system_clock::now().time_since_epoch().count();
default_random_engine rnd(seed);
uniform_real_distribution<double> uniform(0.0, 1.0);

double measure(double lo, double hi) {
  int num = 0, den = 0;
  forn(i, n) if (lo <= age[i] && age[i] < hi) {
    den++;
    num += addicted[i];
  }

  return 1.0 * num / den;
}

vector<pair<double, double>> influence{
  {0, 0}, // 0 year-olds know to abstain
  {12, 2.227966},
  {13, 3.6134655},
  {14, 4.097354},
  {15, 4.300107},
  {16, 5.20536375},
  {17, 5.4757184},
  {19, 5.9609712},
  {23.5, 4.3742811},
  {37, 2.723509},
  {48.5, 1.910963},
  {60, 1.853268},
  {65, 1.750422},
  {1000, 1.750422} // lets say anyone over 65 has the same influenceability as a 65 year old
};

double susceptibility(double age, double friend_age) {
  auto lo = lower_bound(all(influence), pair<double,double>{age, 0});
  auto prev = lo-1;

  double x1 = prev->first, y1 = prev->second;
  double x2 = lo->first, y2 = lo->second;

  double factor = (y2-y1) / (x2-x1) * (age - x1) + y1;

  return 1e-5 * factor / pow(abs(age - friend_age), 0.25);
}

void time_step() {
  vector<bool> nw_addicted(addicted);
  vector<bool> seen(n);

  queue<int> q;
  q.push(0);

  while(!q.empty()) {
    int u = q.front();
    q.pop();
    if (seen[u]) continue;
    seen[u] = 1;

    double ni = (1 - 0.000013); // probability of not influenced
    for (int v : adj[u]) {
      if (addicted[v])
        ni *= (1 - susceptibility(age[u], age[v]));
      q.push(v);
    }

    if (uniform(rnd) > ni)
      nw_addicted[u] = 1;
  }

  swap(nw_addicted, addicted);
}

int main() {
  cout << seed << "\n";
  freopen("graph.txt", "r", stdin);
  ifstream age_in("age.txt");

  int m;
  cin >> n >> m;

  adj.resize(n);
  age.resize(n);
  addicted.resize(n);
  forn(i, m) {
    int a, b;
    cin >> a >> b;

    assert(a < n && b < n);
    adj[a].push_back(b);
    adj[b].push_back(a);
  }

  forn(i, n) age_in >> age[i];

  vector<double> grade8, grade10, grade12, total;
  for(int t = 0;; t++) {
    int a = 0;
    forn(i, n) a += addicted[i];

    grade8.push_back(measure(13, 15));
    grade10.push_back(measure(15, 17));
    grade12.push_back(measure(17, 19));
    total.push_back(1.0 * a / n);

    if (t % 1000 == 0){
      cout << 100.0 * a / n << "\n";
      cout << "\t08: " << grade8.back() << "\n";
      cout << "\t10: " << grade10.back() << "\n";
      cout << "\t12: " << grade12.back() << "\n";
    }

    if (a > 0.80 * n) break;
    time_step();
  }

  ofstream o8("grade8.txt");
  o8 << "{";
  forn(i, grade8.size()) o8 << grade8[i] << ",}"[i == grade8.size() - 1];

  ofstream o10("grade10.txt");
  o10 << "{";
  forn(i, grade10.size()) o10 << grade10[i] << ",}"[i == grade10.size() - 1];

  ofstream o12("grade12.txt");
  o12 << "{";
  forn(i, grade12.size()) o12 << grade12[i] << ",}"[i == grade12.size() - 1];

  ofstream o("total.txt");
  o << "{";
  forn(i, total.size()) o << total[i] << ",}"[i == total.size() - 1];

  o8.close();
  o10.close();
  o12.close();
  o.close();
}

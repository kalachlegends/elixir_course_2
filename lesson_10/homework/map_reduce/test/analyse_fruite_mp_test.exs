defmodule AnalyseFruitsMPTest do
  use ExUnit.Case

  alias AnalyseFruitsMP, as: A

  test "build simple processes tree" do
    assert A.build_processes_tree(
             ["1.csv"],
             4
           ) == {:reducer, {1, 1}, [{:mapper, 1, "1.csv"}]}

    assert A.build_processes_tree(
             ["1.csv", "2.csv"],
             4
           ) ==
             {:reducer, {1, 2},
              [
                {:mapper, 1, "1.csv"},
                {:mapper, 2, "2.csv"}
              ]}

    assert A.build_processes_tree(
             ["1.csv", "2.csv", "3.csv", "4.csv"],
             4
           ) ==
             {:reducer, {1, 4},
              [
                {:mapper, 1, "1.csv"},
                {:mapper, 2, "2.csv"},
                {:mapper, 3, "3.csv"},
                {:mapper, 4, "4.csv"}
              ]}
  end

  test "build complex processes tree" do
    assert A.build_processes_tree(
             ["1.csv", "2.csv", "3.csv", "4.csv"],
             2
           ) ==
             {:reducer, {1, 4},
              [
                {:reducer, {1, 2},
                 [
                   {:mapper, 1, "1.csv"},
                   {:mapper, 2, "2.csv"}
                 ]},
                {:reducer, {3, 4},
                 [
                   {:mapper, 3, "3.csv"},
                   {:mapper, 4, "4.csv"}
                 ]}
              ]}

    assert A.build_processes_tree(
             ["1.csv", "2.csv", "3.csv", "4.csv"],
             3
           ) ==
             {:reducer, {1, 4},
              [
                {:reducer, {1, 3},
                 [
                   {:mapper, 1, "1.csv"},
                   {:mapper, 2, "2.csv"},
                   {:mapper, 3, "3.csv"}
                 ]},
                {:reducer, {4, 4},
                 [
                   {:mapper, 4, "4.csv"}
                 ]}
              ]}
  end

  test "build big processes tree" do
    files = [
      "data_1.csv",
      "data_2.csv",
      "data_3.csv",
      "data_4.csv",
      "data_5.csv",
      "data_6.csv",
      "data_7.csv",
      "data_8.csv",
      "data_9.csv"
    ]

    assert A.build_processes_tree(
             files,
             4
           ) ==
             {:reducer, {1, 9},
              [
                {:reducer, {1, 4},
                 [
                   {:mapper, 1, "data_1.csv"},
                   {:mapper, 2, "data_2.csv"},
                   {:mapper, 3, "data_3.csv"},
                   {:mapper, 4, "data_4.csv"}
                 ]},
                {:reducer, {5, 8},
                 [
                   {:mapper, 5, "data_5.csv"},
                   {:mapper, 6, "data_6.csv"},
                   {:mapper, 7, "data_7.csv"},
                   {:mapper, 8, "data_8.csv"}
                 ]},
                {:reducer, {9, 9},
                 [
                   {:mapper, 9, "data_9.csv"}
                 ]}
              ]}

    assert A.build_processes_tree(
             files,
             3
           ) ==
             {:reducer, {1, 9},
              [
                {:reducer, {1, 3},
                 [
                   {:mapper, 1, "data_1.csv"},
                   {:mapper, 2, "data_2.csv"},
                   {:mapper, 3, "data_3.csv"}
                 ]},
                {:reducer, {4, 6},
                 [
                   {:mapper, 4, "data_4.csv"},
                   {:mapper, 5, "data_5.csv"},
                   {:mapper, 6, "data_6.csv"}
                 ]},
                {:reducer, {7, 9},
                 [
                   {:mapper, 7, "data_7.csv"},
                   {:mapper, 8, "data_8.csv"},
                   {:mapper, 9, "data_9.csv"}
                 ]}
              ]}

    assert A.build_processes_tree(
             files,
             5
           ) ==
             {:reducer, {1, 9},
              [
                {:reducer, {1, 5},
                 [
                   {:mapper, 1, "data_1.csv"},
                   {:mapper, 2, "data_2.csv"},
                   {:mapper, 3, "data_3.csv"},
                   {:mapper, 4, "data_4.csv"},
                   {:mapper, 5, "data_5.csv"}
                 ]},
                {:reducer, {6, 9},
                 [
                   {:mapper, 6, "data_6.csv"},
                   {:mapper, 7, "data_7.csv"},
                   {:mapper, 8, "data_8.csv"},
                   {:mapper, 9, "data_9.csv"}
                 ]}
              ]}
  end

  @tag only: true
  test "build deep processes tree" do
    files = [
      "d1.csv",
      "d2.csv",
      "d3.csv",
      "d4.csv",
      "d5.csv",
      "d6.csv",
      "d7.csv",
      "d8.csv",
      "d9.csv",
      "d10.csv",
      "d11.csv"
    ]

    assert A.build_processes_tree(
             files,
             2
           )

    {:reducer, {1, 11},
     [
       {:reducer, {1, 8},
        [
          {:reducer, {1, 4},
           [
             {:reducer, {1, 2},
              [
                {:mapper, 1, "d1.csv"},
                {:mapper, 2, "d2.csv"}
              ]},
             {:reducer, {3, 4},
              [
                {:mapper, 3, "d3.csv"},
                {:mapper, 4, "d4.csv"}
              ]}
           ]},
          {:reducer, {5, 8},
           [
             {:reducer, {5, 6},
              [
                {:mapper, 5, "d5.csv"},
                {:mapper, 6, "d6.csv"}
              ]},
             {:reducer, {7, 8},
              [
                {:mapper, 7, "d7.csv"},
                {:mapper, 8, "d8.csv"}
              ]}
           ]}
        ]},
       {:reducer, {9, 11},
        [
          {:reducer, {9, 10},
           [
             {:mapper, 9, "d9.csv"},
             {:mapper, 10, "d10.csv"}
           ]},
          {:reducer, {11, 11},
           [
             {:mapper, 11, "d11.csv"}
           ]}
        ]}
     ]}

    # Мое решение
    {:reducer, {1, 11},
     [
       {:reducer, {1, 5},
        [
          {:reducer, {1, 2}, [{:mapper, 1, "d1.csv"}, {:mapper, 2, "d2.csv"}]},
          {:reducer, {3, 5},
           [
             {:reducer, {3, 3}, [{:mapper, 3, "d3.csv"}]},
             {:reducer, {4, 5}, [{:mapper, 4, "d4.csv"}, {:mapper, 5, "d5.csv"}]}
           ]}
        ]},
       {:reducer, {6, 11},
        [
          {:reducer, {6, 8},
           [
             {:reducer, {6, 6}, [{:mapper, 6, "d6.csv"}]},
             {:reducer, {7, 8}, [{:mapper, 7, "d7.csv"}, {:mapper, 8, "d8.csv"}]}
           ]},
          {:reducer, {9, 11},
           [
             {:reducer, {9, 9}, [{:mapper, 9, "d9.csv"}]},
             {:reducer, {10, 11}, [{:mapper, 10, "d10.csv"}, {:mapper, 11, "d11.csv"}]}
           ]}
        ]}
     ]}
  end
end

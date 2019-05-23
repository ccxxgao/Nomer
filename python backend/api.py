from flask import Flask
from flask_restful import Api, Resource, reqparse
from pypinyin import pinyin, lazy_pinyin, Style

import pandas as pd
from sklearn import neighbors, datasets
from sklearn.neighbors import NearestNeighbors
from sklearn.neighbors import KNeighborsClassifier

from googletrans import Translator
import random

import json

app = Flask(__name__)
api = Api(app)

C2E_names = []

#name: Cecily -> Ce, ci, li
def splitter(word):
    translator = Translator()
    vowels = "aeiouy"
    numVowels = 0
    s = []
    t = ""
    last_vowel = 0
    for i in range(0, len(word)):
        for v in vowels:
            if v == word[i]:
                s.append(word[last_vowel:i+1])
                t += translator.translate(word[last_vowel:i+1], dest='zh-cn').text
                last_vowel = i+1
    print(s)
    print(t)
    return t

def convertToEnglish(name, gender):
    names = pd.read_csv('all_names.csv')
    nomes = names[[gender]]
    
    def get_first(name):
        return ord(name[0].lower())

    def get_last(name):
        return ord(name[len(name) - 1])

    nomes['first_char'] = nomes[gender].apply(lambda x: get_first(x))
    nomes['last_char'] = nomes[gender].apply(lambda x: get_last(x))

    X = nomes[['first_char', 'last_char']]
    y = nomes[gender]

    clf = neighbors.NearestNeighbors()
    clf.fit(X, y)

    test = [ord(name[0].lower()), ord(name[len(name) - 1])]

    p = clf.kneighbors([test], 1, return_distance=False)
    p = list(p)

    return_name = []
    for i in p:
        n = nomes.iloc[i]
        return_name.append(n[gender])

    f = return_name[0].tolist()

    for i in f:
        return i

def convertToChinese(name):
    translator = Translator()
    
    split_name = name.split()
    first = translator.translate(split_name[0], dest='zh-cn').text
    first_name = random.sample(first, k=2)
    print(first_name)
    last_name = split_name[1]
    print(last_name)
    
    def get_chns_char(char):
        return ord(char[0])
    
    def get_pinyin(pinyin):
        return ord(pinyin[0])
    
    
    names = ['pinyin', 'surname']
    df = pd.read_csv('chinese_surnames.csv', names=names)
    
    df['pinyin'] = df['pinyin'].apply(lambda x: get_pinyin(x))
    df['surname'] = df['surname'].apply(lambda x: get_chns_char(x))
    
    
    X = df.iloc[:, 0].values
    y = df.iloc[:, 1].values
    
    X = X.reshape(-1, 1)
    
    knn = KNeighborsClassifier(n_neighbors=1)
    knn.fit(X, y)
    
    x_test = [ord(last_name[0].lower())]
    y_pred = knn.predict([x_test])
    
    last = chr(y_pred)
    
    for i in first_name:
        last += i
    return last

class Name(Resource):
    def post(self, language):
        parser = reqparse.RequestParser()
        print("HERE")
        parser.add_argument("name")
        parser.add_argument("gender")
        args = parser.parse_args()

        if (language == "Chinese"):
            print("Chinese -> English")
            py = pinyin.get(str(args["name"]), format="strip", delimiter=" ")
            rn = convertToEnglish(py, str(args["gender"]))
            return rn, 201
                
        elif (language == "English"):
            print("English -> Chinese")
            rn = convertToChinese(str(args["name"]))
            print(rn)
#            rn = convertToChinese(str(args["name"]), str(args["gender"]))
            return rn, 201


api.add_resource(Name, "/<string:language>")


app.run(debug=True)


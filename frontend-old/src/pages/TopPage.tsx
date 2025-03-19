import React, { useEffect, useState } from 'react';
import styled from 'styled-components';
import axios from 'axios';
import { Link } from 'react-router-dom';

const Container = styled.div`
  max-width: 800px;
  margin: 0 auto;
  padding: 2rem;
`;

const Title = styled.h2`
  color: #1da1f2;
  margin-bottom: 2rem;
`;

const PostList = styled.div`
  display: flex;
  flex-direction: column;
  gap: 1rem;
`;

const PostItem = styled.div`
  border: 1px solid #e1e8ed;
  border-radius: 8px;
  padding: 1rem;
  background-color: white;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
`;

const PostHeader = styled.div`
  display: flex;
  align-items: center;
  margin-bottom: 0.5rem;
`;

const AuthorName = styled.span`
  font-weight: bold;
  margin-right: 0.5rem;
`;

const Username = styled.span`
  color: #657786;
`;

const PostContent = styled.p`
  margin-bottom: 1rem;
`;

const PostFooter = styled.div`
  display: flex;
  justify-content: space-between;
  align-items: center;
  color: #657786;
`;

const LikesCount = styled.span``;

const PostDate = styled.span``;

const SelectButton = styled(Link)`
  display: inline-block;
  background-color: #1da1f2;
  color: white;
  padding: 0.5rem 1rem;
  border-radius: 20px;
  text-decoration: none;
  font-weight: bold;
  &:hover {
    background-color: #1a91da;
  }
`;

interface Post {
  id: number;
  x_post_id: string;
  content: string;
  author_username: string;
  author_name: string;
  likes_count: number;
  posted_at: string;
}

const API_BASE_URL = 'http://localhost:3000/api/v1';

const TopPage: React.FC = ()  => {
  const [posts, setPosts] = useState<Post[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchPosts = async () => {
      try {
        const response = await axios.get(`${API_BASE_URL}/posts`);
        setPosts(response.data);
        setLoading(false);
      } catch (err) {
        setError('ポストの取得に失敗しました');
        setLoading(false);
        console.error(err);
      }
    };

    fetchPosts();
  }, []);

  if (loading) return <Container><p>読み込み中...</p></Container>;
  if (error) return <Container><p>エラー: {error}</p></Container>;

  return (
    <Container>
      <Title>最新のポスト</Title>
      <PostList>
        {posts.length === 0 ? (
          <p>表示するポストがありません。</p>
        ) : (
          posts.map((post) => (
            <PostItem key={post.id}>
              <PostHeader>
                <AuthorName>{post.author_name}</AuthorName>
                <Username>@{post.author_username}</Username>
              </PostHeader>
              <PostContent>{post.content}</PostContent>
              <PostFooter>
                <div>
                  <LikesCount>♥ {post.likes_count}いいね</LikesCount>
                  <PostDate> · {new Date(post.posted_at).toLocaleDateString()}</PostDate>
                </div>
                <SelectButton to={`/posts/${post.id}`}>選択する</SelectButton>
              </PostFooter>
            </PostItem>
          ))
        )}
      </PostList>
    </Container>
  );
};

export default TopPage;

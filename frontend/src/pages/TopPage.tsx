import React, { useState, useEffect } from 'react';
import axios from 'axios';
import styled from 'styled-components';
import { Link } from 'react-router-dom';

const API_BASE_URL = 'http://localhost:3000/api/v1';

interface Post {
  id: number;
  x_post_id: string;
  content: string;
  author_username: string;
  author_name: string;
  likes_count: number;
  posted_at: string;
  used: boolean;
}

const TopPage: React.FC = () => {
  const [posts, setPosts] = useState<Post[]>([]);
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchPosts = async () => {
      try {
        setLoading(true);
        const response = await axios.get(`${API_BASE_URL}/posts`, {
          auth: {
            username: 'admin', // Basic認証のユーザー名
            password: 'password' // Basic認証のパスワード
          }
        });
        setPosts(response.data);
        setError(null);
      } catch (err) {
        console.error('Error fetching posts:', err);
        setError('投稿の取得中にエラーが発生しました。');
      } finally {
        setLoading(false);
      }
    };

    fetchPosts();
  }, []);

  return (
    <Container>
      <Title>X投稿管理システム</Title>
      <Subtitle>開発・AIに関する投稿一覧</Subtitle>
      
      {loading && <Loading>読み込み中...</Loading>}
      {error && <Error>{error}</Error>}
      
      <PostList>
        {posts.map(post => (
          <PostItem key={post.id}>
            <PostContent>{post.content}</PostContent>
            <PostMeta>
              <Author>@{post.author_username}</Author>
              <LikesCount>♥ {post.likes_count}</LikesCount>
              <PostDate>{new Date(post.posted_at).toLocaleDateString('ja-JP')}</PostDate>
            </PostMeta>
            <SelectButton to={`/posts/${post.id}`}>選択する</SelectButton>
          </PostItem>
        ))}
      </PostList>
      
      {posts.length === 0 && !loading && <NoData>投稿が見つかりませんでした。</NoData>}
    </Container>
  );
};

const Container = styled.div`
  max-width: 800px;
  margin: 0 auto;
  padding: 20px;
`;

const Title = styled.h1`
  font-size: 24px;
  margin-bottom: 10px;
  color: #333;
`;

const Subtitle = styled.h2`
  font-size: 18px;
  margin-bottom: 20px;
  color: #666;
`;

const PostList = styled.div`
  display: flex;
  flex-direction: column;
  gap: 20px;
`;

const PostItem = styled.div`
  border: 1px solid #ddd;
  border-radius: 8px;
  padding: 15px;
  background-color: #fff;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
`;

const PostContent = styled.p`
  margin-bottom: 10px;
  line-height: 1.5;
`;

const PostMeta = styled.div`
  display: flex;
  align-items: center;
  margin-bottom: 10px;
  font-size: 14px;
  color: #666;
`;

const Author = styled.span`
  margin-right: 15px;
`;

const LikesCount = styled.span`
  margin-right: 15px;
  color: #e0245e;
`;

const PostDate = styled.span``;

const SelectButton = styled(Link)`
  display: inline-block;
  background-color: #1da1f2;
  color: white;
  padding: 8px 16px;
  border-radius: 4px;
  text-decoration: none;
  font-weight: bold;
  transition: background-color 0.2s;
  
  &:hover {
    background-color: #0c85d0;
  }
`;

const Loading = styled.div`
  text-align: center;
  padding: 20px;
  color: #666;
`;

const Error = styled.div`
  color: #e0245e;
  padding: 10px;
  margin-bottom: 20px;
  border: 1px solid #e0245e;
  border-radius: 4px;
  background-color: #fde8ec;
`;

const NoData = styled.div`
  text-align: center;
  padding: 30px;
  color: #666;
  font-style: italic;
`;

export default TopPage;

import React, { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import axios from 'axios';
import styled from 'styled-components';

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

interface GeneratedPost {
  id: number;
  original_post_id: number;
  content: string;
  posted: boolean;
  posted_at: string | null;
}

const PostDetailPage: React.FC = () => {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  const [post, setPost] = useState<Post | null>(null);
  const [generatedPost, setGeneratedPost] = useState<GeneratedPost | null>(null);
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);
  const [publishing, setPublishing] = useState<boolean>(false);
  const [generating, setGenerating] = useState<boolean>(false);

  useEffect(() => {
    const fetchPost = async () => {
      try {
        setLoading(true);
        const response = await axios.get(`${API_BASE_URL}/posts/${id}`, {
          auth: {
            username: 'admin', // Basic認証のユーザー名
            password: 'password' // Basic認証のパスワード
          }
        });
        setPost(response.data);
        setError(null);
      } catch (err) {
        console.error('Error fetching post:', err);
        setError('投稿の取得中にエラーが発生しました。');
      } finally {
        setLoading(false);
      }
    };

    if (id) {
      fetchPost();
    }
  }, [id]);

  const handleGenerate = async () => {
    try {
      setGenerating(true);
      const response = await axios.post(
        `${API_BASE_URL}/posts/${id}/generate`,
        {},
        {
          auth: {
            username: 'admin',
            password: 'password'
          }
        }
      );
      setGeneratedPost(response.data);
      setError(null);
    } catch (err) {
      console.error('Error generating post:', err);
      setError('投稿の生成中にエラーが発生しました。');
    } finally {
      setGenerating(false);
    }
  };

  const handlePublish = async () => {
    if (!generatedPost) return;
    
    try {
      setPublishing(true);
      await axios.post(
        `${API_BASE_URL}/posts/${id}/publish`,
        { generated_post_id: generatedPost.id },
        {
          auth: {
            username: 'admin',
            password: 'password'
          }
        }
      );
      
      // 投稿成功後、トップページに戻る
      alert('投稿が完了しました！');
      navigate('/');
      
    } catch (err) {
      console.error('Error publishing post:', err);
      setError('Xへの投稿中にエラーが発生しました。');
      setPublishing(false);
    }
  };

  if (loading) {
    return <Loading>読み込み中...</Loading>;
  }

  if (error) {
    return <Error>{error}</Error>;
  }

  if (!post) {
    return <NoData>投稿が見つかりませんでした。</NoData>;
  }

  return (
    <Container>
      <Title>ポスト詳細</Title>
      
      <ContentContainer>
        <LeftPanel>
          <OriginalPostContainer>
            <SectionTitle>選択したポスト</SectionTitle>
            <PostContent>{post.content}</PostContent>
            <PostMeta>
              <Author>@{post.author_username}</Author>
              <LikesCount>♥ {post.likes_count}</LikesCount>
              <PostDate>{new Date(post.posted_at).toLocaleDateString('ja-JP')}</PostDate>
            </PostMeta>
          </OriginalPostContainer>
          
          <ButtonContainer>
            <GenerateButton onClick={handleGenerate} disabled={generating}>
              {generating ? '変換中...' : '変換する'}
            </GenerateButton>
          </ButtonContainer>
        </LeftPanel>
        
        <RightPanel>
          <GeneratedPostContainer>
            <SectionTitle>変換されたポスト</SectionTitle>
            <GeneratedContent 
              value={generatedPost?.content || ''} 
              readOnly
              placeholder="「変換する」ボタンを押すと、ここに変換されたテキストが表示されます。"
            />
          </GeneratedPostContainer>
          
          <ButtonContainer>
            <PublishButton 
              onClick={handlePublish} 
              disabled={!generatedPost || publishing}
            >
              {publishing ? '投稿中...' : 'Xに投稿する'}
            </PublishButton>
          </ButtonContainer>
        </RightPanel>
      </ContentContainer>
      
      <BackButton onClick={() => navigate('/')}>トップページに戻る</BackButton>
    </Container>
  );
};

const Container = styled.div`
  max-width: 1000px;
  margin: 0 auto;
  padding: 20px;
`;

const Title = styled.h1`
  font-size: 24px;
  margin-bottom: 20px;
  color: #333;
`;

const ContentContainer = styled.div`
  display: flex;
  gap: 20px;
  margin-bottom: 20px;
  
  @media (max-width: 768px) {
    flex-direction: column;
  }
`;

const LeftPanel = styled.div`
  flex: 1;
  display: flex;
  flex-direction: column;
`;

const RightPanel = styled.div`
  flex: 1;
  display: flex;
  flex-direction: column;
`;

const SectionTitle = styled.h2`
  font-size: 18px;
  margin-bottom: 10px;
  color: #666;
`;

const OriginalPostContainer = styled.div`
  border: 1px solid #ddd;
  border-radius: 8px;
  padding: 15px;
  background-color: #fff;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
  margin-bottom: 15px;
  flex-grow: 1;
`;

const GeneratedPostContainer = styled.div`
  border: 1px solid #ddd;
  border-radius: 8px;
  padding: 15px;
  background-color: #fff;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
  margin-bottom: 15px;
  flex-grow: 1;
  display: flex;
  flex-direction: column;
`;

const PostContent = styled.p`
  margin-bottom: 10px;
  line-height: 1.5;
`;

const GeneratedContent = styled.textarea`
  width: 100%;
  min-height: 150px;
  border: 1px solid #ddd;
  border-radius: 4px;
  padding: 10px;
  font-family: inherit;
  font-size: inherit;
  line-height: 1.5;
  resize: vertical;
  flex-grow: 1;
`;

const PostMeta = styled.div`
  display: flex;
  align-items: center;
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

const ButtonContainer = styled.div`
  display: flex;
  justify-content: center;
  margin-bottom: 15px;
`;

const GenerateButton = styled.button`
  background-color: #1da1f2;
  color: white;
  padding: 10px 20px;
  border: none;
  border-radius: 4px;
  font-weight: bold;
  cursor: pointer;
  transition: background-color 0.2s;
  
  &:hover:not(:disabled) {
    background-color: #0c85d0;
  }
  
  &:disabled {
    background-color: #9ad2f6;
    cursor: not-allowed;
  }
`;

const PublishButton = styled.button`
  background-color: #17bf63;
  color: white;
  padding: 10px 20px;
  border: none;
  border-radius: 4px;
  font-weight: bold;
  cursor: pointer;
  transition: background-color 0.2s;
  
  &:hover:not(:disabled) {
    background-color: #0f9d4f;
  }
  
  &:disabled {
    background-color: #a8e2c3;
    cursor: not-allowed;
  }
`;

const BackButton = styled.button`
  background-color: #f7f9fa;
  color: #1da1f2;
  border: 1px solid #1da1f2;
  padding: 8px 16px;
  border-radius: 4px;
  font-weight: bold;
  cursor: pointer;
  transition: background-color 0.2s;
  
  &:hover {
    background-color: #e8f5fe;
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

export default PostDetailPage;

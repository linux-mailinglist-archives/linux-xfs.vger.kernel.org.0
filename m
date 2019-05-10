Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42D8F1A4A3
	for <lists+linux-xfs@lfdr.de>; Fri, 10 May 2019 23:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728156AbfEJVlE (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 10 May 2019 17:41:04 -0400
Received: from sandeen.net ([63.231.237.45]:42730 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727828AbfEJVlE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 10 May 2019 17:41:04 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 6CCF57BA9;
        Fri, 10 May 2019 16:40:52 -0500 (CDT)
Subject: Re: [PATCH 05/11] libxfs: de-libxfsify core(-ish) functions.
To:     Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org
References: <1557519510-10602-1-git-send-email-sandeen@redhat.com>
 <1557519510-10602-6-git-send-email-sandeen@redhat.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Openpgp: preference=signencrypt
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 mQINBE6x99QBEADMR+yNFBc1Y5avoUhzI/sdR9ANwznsNpiCtZlaO4pIWvqQJCjBzp96cpCs
 nQZV32nqJBYnDpBDITBqTa/EF+IrHx8gKq8TaSBLHUq2ju2gJJLfBoL7V3807PQcI18YzkF+
 WL05ODFQ2cemDhx5uLghHEeOxuGj+1AI+kh/FCzMedHc6k87Yu2ZuaWF+Gh1W2ix6hikRJmQ
 vj5BEeAx7xKkyBhzdbNIbbjV/iGi9b26B/dNcyd5w2My2gxMtxaiP7q5b6GM2rsQklHP8FtW
 ZiYO7jsg/qIppR1C6Zr5jK1GQlMUIclYFeBbKggJ9mSwXJH7MIftilGQ8KDvNuV5AbkronGC
 sEEHj2khs7GfVv4pmUUHf1MRIvV0x3WJkpmhuZaYg8AdJlyGKgp+TQ7B+wCjNTdVqMI1vDk2
 BS6Rg851ay7AypbCPx2w4d8jIkQEgNjACHVDU89PNKAjScK1aTnW+HNUqg9BliCvuX5g4z2j
 gJBs57loTWAGe2Ve3cMy3VoQ40Wt3yKK0Eno8jfgzgb48wyycINZgnseMRhxc2c8hd51tftK
 LKhPj4c7uqjnBjrgOVaVBupGUmvLiePlnW56zJZ51BR5igWnILeOJ1ZIcf7KsaHyE6B1mG+X
 dmYtjDhjf3NAcoBWJuj8euxMB6TcQN2MrSXy5wSKaw40evooGwARAQABtCVFcmljIFIuIFNh
 bmRlZW4gPHNhbmRlZW5Ac2FuZGVlbi5uZXQ+iQI7BBMBAgAlAhsDBgsJCAcDAgYVCAIJCgsE
 FgIDAQIeAQIXgAUCUzMzbAIZAQAKCRAgrhaS4T3e4Fr7D/wO+fenqVvHjq21SCjDCrt8HdVj
 aJ28B1SqSU2toxyg5I160GllAxEHpLFGdbFAhQfBtnmlY9eMjwmJb0sCIrkrB6XNPSPA/B2B
 UPISh0z2odJv35/euJF71qIFgWzp2czJHkHWwVZaZpMWWNvsLIroXoR+uA9c2V1hQFVAJZyk
 EE4xzfm1+oVtjIC12B9tTCuS00pY3AUy21yzNowT6SSk7HAzmtG/PJ/uSB5wEkwldB6jVs2A
 sjOg1wMwVvh/JHilsQg4HSmDfObmZj1d0RWlMWcUE7csRnCE0ZWBMp/ttTn+oosioGa09HAS
 9jAnauznmYg43oQ5Akd8iQRxz5I58F/+JsdKvWiyrPDfYZtFS+UIgWD7x+mHBZ53Qjazszox
 gjwO9ehZpwUQxBm4I0lPDAKw3HJA+GwwiubTSlq5PS3P7QoCjaV8llH1bNFZMz2o8wPANiDx
 5FHgpRVgwLHakoCU1Gc+LXHXBzDXt7Cj02WYHdFzMm2hXaslRdhNGowLo1SXZFXa41KGTlNe
 4di53y9CK5ynV0z+YUa+5LR6RdHrHtgywdKnjeWdqhoVpsWIeORtwWGX8evNOiKJ7j0RsHha
 WrePTubr5nuYTDsQqgc2r4aBIOpeSRR2brlT/UE3wGgy9LY78L4EwPR0MzzecfE1Ws60iSqw
 Pu3vhb7h3bkCDQROsffUARAA0DrUifTrXQzqxO8aiQOC5p9Tz25Np/Tfpv1rofOwL8VPBMvJ
 X4P5l1V2yd70MZRUVgjmCydEyxLJ6G2YyHO2IZTEajUY0Up+b3ErOpLpZwhvgWatjifpj6bB
 SKuDXeThqFdkphF5kAmgfVAIkan5SxWK3+S0V2F/oxstIViBhMhDwI6XsRlnVBoLLYcEilxA
 2FlRUS7MOZGmRJkRtdGD5koVZSM6xVZQSmfEBaYQ/WJBGJQdPy94nnlAVn3lH3+N7pXvNUuC
 GV+t4YUt3tLcRuIpYBCOWlc7bpgeCps5Xa0dIZgJ8Louu6OBJ5vVXjPxTlkFdT0S0/uerCG5
 1u8p6sGRLnUeAUGkQfIUqGUjW2rHaXgWNvzOV6i3tf9YaiXKl3avFaNW1kKBs0T5M1cnlWZU
 Utl6k04lz5OjoNY9J/bGyV3DSlkblXRMK87iLYQSrcV6cFz9PRl4vW1LGff3xRQHngeN5fPx
 ze8X5NE3hb+SSwyMSEqJxhVTXJVfQWWW0dQxP7HNwqmOWYF/6m+1gK/Y2gY3jAQnsWTru4RV
 TZGnKwEPmOCpSUvsTRXsVHgsWJ70qd0yOSjWuiv4b8vmD3+QFgyvCBxPMdP3xsxN5etheLMO
 gRwWpLn6yNFq/xtgs+ECgG+gR78yXQyA7iCs5tFs2OrMqV5juSMGmn0kxJUAEQEAAYkCHwQY
 AQIACQUCTrH31AIbDAAKCRAgrhaS4T3e4BKwD/0ZOOmUNOZCSOLAMjZx3mtYtjYgfUNKi0ki
 YPveGoRWTqbis8UitPtNrG4XxgzLOijSdOEzQwkdOIp/QnZhGNssMejCnsluK0GQd+RkFVWN
 mcQT78hBeGcnEMAXZKq7bkIKzvc06GFmkMbX/gAl6DiNGv0UNAX+5FYh+ucCJZSyAp3sA+9/
 LKjxnTedX0aygXA6rkpX0Y0FvN/9dfm47+LGq7WAqBOyYTU3E6/+Z72bZoG/cG7ANLxcPool
 LOrU43oqFnD8QwcN56y4VfFj3/jDF2MX3xu4v2OjglVjMEYHTCxP3mpxesGHuqOit/FR+mF0
 MP9JGfj6x+bj/9JMBtCW1bY/aPeMdPGTJvXjGtOVYblGZrSjXRn5++Uuy36CvkcrjuziSDG+
 JEexGxczWwN4mrOQWhMT5Jyb+18CO+CWxJfHaYXiLEW7dI1AynL4jjn4W0MSiXpWDUw+fsBO
 Pk6ah10C4+R1Jc7dyUsKksMfvvhRX1hTIXhth85H16706bneTayZBhlZ/hK18uqTX+s0onG/
 m1F3vYvdlE4p2ts1mmixMF7KajN9/E5RQtiSArvKTbfsB6Two4MthIuLuf+M0mI4gPl9SPlf
 fWCYVPhaU9o83y1KFbD/+lh1pjP7bEu/YudBvz7F2Myjh4/9GUAijrCTNeDTDAgvIJDjXuLX pA==
Message-ID: <b78a858b-8be1-ced1-0f16-f4a916a2e2ca@sandeen.net>
Date:   Fri, 10 May 2019 16:41:03 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1557519510-10602-6-git-send-email-sandeen@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 5/10/19 3:18 PM, Eric Sandeen wrote:
> There are a ton of "libxfs_" prefixed functions in libxfs/trans.c which
> are only called internally by code in libxfs/ - As I understand it,
> these should probably be just "xfs_" functions, and indeed many
> of them have counterparts in the kernel libxfs/ code.  This is one
> small step towards better sync-up of some of the misc libxfs/*
> transaction code with kernel code.

I should have changed internal callers too, will resend after other
review.

> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>  libxfs/libxfs_api_defs.h |  1 +
>  libxfs/trans.c           | 48 ++++++++++++++++++++++++------------------------
>  2 files changed, 25 insertions(+), 24 deletions(-)
> 
> diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
> index 1150ec9..64030af 100644
> --- a/libxfs/libxfs_api_defs.h
> +++ b/libxfs/libxfs_api_defs.h
> @@ -17,6 +17,7 @@
>  #define xfs_highbit64			libxfs_highbit64
>  
>  #define xfs_trans_alloc			libxfs_trans_alloc
> +#define xfs_trans_alloc_rollable	libxfs_trans_alloc_rollable
>  #define xfs_trans_alloc_empty		libxfs_trans_alloc_empty
>  #define xfs_trans_add_item		libxfs_trans_add_item
>  #define xfs_trans_bhold			libxfs_trans_bhold
> diff --git a/libxfs/trans.c b/libxfs/trans.c
> index 581ece3..85c3a50 100644
> --- a/libxfs/trans.c
> +++ b/libxfs/trans.c
> @@ -36,7 +36,7 @@ kmem_zone_t	*xfs_trans_zone;
>   * in the mount structure.
>   */
>  void
> -libxfs_trans_init(
> +xfs_trans_init(
>  	struct xfs_mount	*mp)
>  {
>  	xfs_trans_resv_calc(mp, &mp->m_resv);
> @@ -46,7 +46,7 @@ libxfs_trans_init(
>   * Add the given log item to the transaction's list of log items.
>   */
>  void
> -libxfs_trans_add_item(
> +xfs_trans_add_item(
>  	struct xfs_trans	*tp,
>  	struct xfs_log_item	*lip)
>  {
> @@ -62,7 +62,7 @@ libxfs_trans_add_item(
>   * Unlink and free the given descriptor.
>   */
>  void
> -libxfs_trans_del_item(
> +xfs_trans_del_item(
>  	struct xfs_log_item	*lip)
>  {
>  	clear_bit(XFS_LI_DIRTY, &lip->li_flags);
> @@ -77,7 +77,7 @@ libxfs_trans_del_item(
>   * chunk we've been working on and get a new transaction to continue.
>   */
>  int
> -libxfs_trans_roll(
> +xfs_trans_roll(
>  	struct xfs_trans	**tpp)
>  {
>  	struct xfs_trans	*trans = *tpp;
> @@ -245,7 +245,7 @@ undo_blocks:
>  }
>  
>  int
> -libxfs_trans_alloc(
> +xfs_trans_alloc(
>  	struct xfs_mount	*mp,
>  	struct xfs_trans_res	*resp,
>  	unsigned int		blocks,
> @@ -289,7 +289,7 @@ libxfs_trans_alloc(
>   * without any dirty data.
>   */
>  int
> -libxfs_trans_alloc_empty(
> +xfs_trans_alloc_empty(
>  	struct xfs_mount		*mp,
>  	struct xfs_trans		**tpp)
>  {
> @@ -304,7 +304,7 @@ libxfs_trans_alloc_empty(
>   * permanent log reservation flag to avoid blowing asserts.
>   */
>  int
> -libxfs_trans_alloc_rollable(
> +xfs_trans_alloc_rollable(
>  	struct xfs_mount	*mp,
>  	unsigned int		blocks,
>  	struct xfs_trans	**tpp)
> @@ -314,7 +314,7 @@ libxfs_trans_alloc_rollable(
>  }
>  
>  void
> -libxfs_trans_cancel(
> +xfs_trans_cancel(
>  	struct xfs_trans	*tp)
>  {
>  #ifdef XACT_DEBUG
> @@ -337,7 +337,7 @@ out:
>  }
>  
>  void
> -libxfs_trans_ijoin(
> +xfs_trans_ijoin(
>  	xfs_trans_t		*tp,
>  	xfs_inode_t		*ip,
>  	uint			lock_flags)
> @@ -360,7 +360,7 @@ libxfs_trans_ijoin(
>  }
>  
>  void
> -libxfs_trans_ijoin_ref(
> +xfs_trans_ijoin_ref(
>  	xfs_trans_t		*tp,
>  	xfs_inode_t		*ip,
>  	int			lock_flags)
> @@ -375,7 +375,7 @@ libxfs_trans_ijoin_ref(
>  }
>  
>  void
> -libxfs_trans_inode_alloc_buf(
> +xfs_trans_inode_alloc_buf(
>  	xfs_trans_t		*tp,
>  	xfs_buf_t		*bp)
>  {
> @@ -422,7 +422,7 @@ xfs_trans_log_inode(
>  }
>  
>  int
> -libxfs_trans_roll_inode(
> +xfs_trans_roll_inode(
>  	struct xfs_trans	**tpp,
>  	struct xfs_inode	*ip)
>  {
> @@ -440,7 +440,7 @@ libxfs_trans_roll_inode(
>   * Mark a buffer dirty in the transaction.
>   */
>  void
> -libxfs_trans_dirty_buf(
> +xfs_trans_dirty_buf(
>  	struct xfs_trans	*tp,
>  	struct xfs_buf		*bp)
>  {
> @@ -466,7 +466,7 @@ libxfs_trans_dirty_buf(
>   * value of b_blkno.
>   */
>  void
> -libxfs_trans_log_buf(
> +xfs_trans_log_buf(
>  	struct xfs_trans	*tp,
>  	struct xfs_buf		*bp,
>  	uint			first,
> @@ -488,7 +488,7 @@ libxfs_trans_log_buf(
>   * If the buffer is already dirty, trigger the "already logged" return condition.
>   */
>  bool
> -libxfs_trans_ordered_buf(
> +xfs_trans_ordered_buf(
>  	struct xfs_trans	*tp,
>  	struct xfs_buf		*bp)
>  {
> @@ -511,7 +511,7 @@ xfs_buf_item_put(
>  }
>  
>  void
> -libxfs_trans_brelse(
> +xfs_trans_brelse(
>  	xfs_trans_t		*tp,
>  	xfs_buf_t		*bp)
>  {
> @@ -546,7 +546,7 @@ libxfs_trans_brelse(
>  }
>  
>  void
> -libxfs_trans_binval(
> +xfs_trans_binval(
>  	xfs_trans_t		*tp,
>  	xfs_buf_t		*bp)
>  {
> @@ -571,7 +571,7 @@ libxfs_trans_binval(
>  }
>  
>  void
> -libxfs_trans_bjoin(
> +xfs_trans_bjoin(
>  	xfs_trans_t		*tp,
>  	xfs_buf_t		*bp)
>  {
> @@ -589,7 +589,7 @@ libxfs_trans_bjoin(
>  }
>  
>  void
> -libxfs_trans_bhold(
> +xfs_trans_bhold(
>  	xfs_trans_t		*tp,
>  	xfs_buf_t		*bp)
>  {
> @@ -605,7 +605,7 @@ libxfs_trans_bhold(
>  }
>  
>  xfs_buf_t *
> -libxfs_trans_get_buf_map(
> +xfs_trans_get_buf_map(
>  	xfs_trans_t		*tp,
>  	struct xfs_buftarg	*btp,
>  	struct xfs_buf_map	*map,
> @@ -641,7 +641,7 @@ libxfs_trans_get_buf_map(
>  }
>  
>  xfs_buf_t *
> -libxfs_trans_getsb(
> +xfs_trans_getsb(
>  	xfs_trans_t		*tp,
>  	xfs_mount_t		*mp,
>  	int			flags)
> @@ -675,7 +675,7 @@ libxfs_trans_getsb(
>  }
>  
>  int
> -libxfs_trans_read_buf_map(
> +xfs_trans_read_buf_map(
>  	xfs_mount_t		*mp,
>  	xfs_trans_t		*tp,
>  	struct xfs_buftarg	*btp,
> @@ -743,7 +743,7 @@ out_relse:
>   * Originally derived from xfs_trans_mod_sb().
>   */
>  void
> -libxfs_trans_mod_sb(
> +xfs_trans_mod_sb(
>  	xfs_trans_t		*tp,
>  	uint			field,
>  	long			delta)
> @@ -1004,7 +1004,7 @@ out_unreserve:
>  }
>  
>  int
> -libxfs_trans_commit(
> +xfs_trans_commit(
>  	struct xfs_trans	*tp)
>  {
>  	return __xfs_trans_commit(tp, false);
> 

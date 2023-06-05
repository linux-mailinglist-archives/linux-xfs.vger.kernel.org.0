Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23730722D7E
	for <lists+linux-xfs@lfdr.de>; Mon,  5 Jun 2023 19:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234541AbjFERTN (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 5 Jun 2023 13:19:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235358AbjFERTL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Jun 2023 13:19:11 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6E4B110A
        for <linux-xfs@vger.kernel.org>; Mon,  5 Jun 2023 10:19:10 -0700 (PDT)
Received: from [10.0.0.71] (liberator.sandeen.net [10.0.0.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPS id 3190A48C71A;
        Mon,  5 Jun 2023 12:19:10 -0500 (CDT)
Message-ID: <60597c59-5f07-0b2a-5a6d-a32ce644b4a2@sandeen.net>
Date:   Mon, 5 Jun 2023 12:19:09 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.2
Subject: Re: [PATCH 3/5] xfs_db: fix metadump name obfuscation for ascii-ci
 filesystems
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
References: <168597938725.1226098.18077307069307502725.stgit@frogsfrogsfrogs>
 <168597940416.1226098.14610650380180437820.stgit@frogsfrogsfrogs>
From:   Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <168597940416.1226098.14610650380180437820.stgit@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_PASS,T_FILL_THIS_FORM_SHORT,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 6/5/23 10:36 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Now that we've stabilized the dirent hash function for ascii-ci
> filesystems, adapt the metadump name obfuscation code to detect when
> it's obfuscating a directory entry name on an ascii-ci filesystem and
> spit out names that actually have the same hash.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>   db/metadump.c |   77 ++++++++++++++++++++++++++++++++++++++++++++++++++-------
>   1 file changed, 68 insertions(+), 9 deletions(-)
> 
> 
> diff --git a/db/metadump.c b/db/metadump.c
> index 317ff72802d..4f8b3adb163 100644
> --- a/db/metadump.c
> +++ b/db/metadump.c
> @@ -817,13 +817,17 @@ static void
>   obfuscate_name(
>   	xfs_dahash_t	hash,
>   	size_t		name_len,
> -	unsigned char	*name)
> +	unsigned char	*name,
> +	bool		is_dirent)
>   {
> -	unsigned char	*newp = name;
> +	unsigned char	*oldname = NULL;
> +	unsigned char	*newp;
>   	int		i;
> -	xfs_dahash_t	new_hash = 0;
> +	xfs_dahash_t	new_hash;
>   	unsigned char	*first;
>   	unsigned char	high_bit;
> +	int		tries = 0;
> +	bool		is_ci_name = is_dirent && xfs_has_asciici(mp);
>   	int		shift;
>   
>   	/*
> @@ -836,6 +840,24 @@ obfuscate_name(
>   	if (name_len < 5)
>   		return;
>   
> +	if (is_ci_name) {
> +		oldname = alloca(name_len);
> +		memcpy(oldname, name, name_len);
> +	}
> +
> +again:
> +	newp = name;
> +	new_hash = 0;
> +
> +	/*
> +	 * If we cannot generate a ci-compatible obfuscated name after 1000
> +	 * tries, don't bother obfuscating the name.
> +	 */
> +	if (tries++ > 1000) {
> +		memcpy(name, oldname, name_len);
> +		return;
> +	}
> +
>   	/*
>   	 * The beginning of the obfuscated name can be pretty much
>   	 * anything, so fill it in with random characters.
> @@ -843,7 +865,11 @@ obfuscate_name(
>   	 */
>   	for (i = 0; i < name_len - 5; i++) {
>   		*newp = random_filename_char();
> -		new_hash = *newp ^ rol32(new_hash, 7);
> +		if (is_ci_name)
> +			new_hash = xfs_ascii_ci_xfrm(*newp) ^
> +							rol32(new_hash, 7);
> +		else
> +			new_hash = *newp ^ rol32(new_hash, 7);
>   		newp++;
>   	}
>   
> @@ -867,6 +893,17 @@ obfuscate_name(
>   			high_bit = 0x80;
>   		} else
>   			high_bit = 0;
> +
> +		/*
> +		 * If ascii-ci is enabled, uppercase characters are converted
> +		 * to lowercase characters while computing the name hash.  If
> +		 * any of the necessary correction bytes are uppercase, the
> +		 * hash of the new name will not match.  Try again with a
> +		 * different prefix.
> +		 */
> +		if (is_ci_name && xfs_ascii_ci_need_xfrm(*newp))
> +			goto again;
> +
>   		ASSERT(!is_invalid_char(*newp));
>   		newp++;
>   	}
> @@ -880,6 +917,10 @@ obfuscate_name(
>   	 */
>   	if (high_bit) {
>   		*first ^= 0x10;
> +
> +		if (is_ci_name && xfs_ascii_ci_need_xfrm(*first))
> +			goto again;
> +
>   		ASSERT(!is_invalid_char(*first));
>   	}
>   }
> @@ -1177,6 +1218,24 @@ handle_duplicate_name(xfs_dahash_t hash, size_t name_len, unsigned char *name)
>   	return 1;
>   }
>   
> +static inline xfs_dahash_t
> +dirattr_hashname(
> +	bool		is_dirent,
> +	const uint8_t	*name,
> +	int		namelen)
> +{
> +	if (is_dirent) {
> +		struct xfs_name	xname = {
> +			.name	= name,
> +			.len	= namelen,
> +		};
> +
> +		return libxfs_dir2_hashname(mp, &xname);
> +	}
> +
> +	return libxfs_da_hashname(name, namelen);
> +}
> +
>   static void
>   generate_obfuscated_name(
>   	xfs_ino_t		ino,
> @@ -1205,9 +1264,9 @@ generate_obfuscated_name(
>   
>   	/* Obfuscate the name (if possible) */
>   
> -	hash = libxfs_da_hashname(name, namelen);
> -	obfuscate_name(hash, namelen, name);
> -	ASSERT(hash == libxfs_da_hashname(name, namelen));
> +	hash = dirattr_hashname(ino != 0, name, namelen);
> +	obfuscate_name(hash, namelen, name, ino != 0);
> +	ASSERT(hash == dirattr_hashname(ino != 0, name, namelen));
>   
>   	/*
>   	 * Make sure the name is not something already seen.  If we
> @@ -1320,7 +1379,7 @@ obfuscate_path_components(
>   			/* last (or single) component */
>   			namelen = strnlen((char *)comp, len);
>   			hash = libxfs_da_hashname(comp, namelen);
> -			obfuscate_name(hash, namelen, comp);
> +			obfuscate_name(hash, namelen, comp, false);
>   			ASSERT(hash == libxfs_da_hashname(comp, namelen));
>   			break;
>   		}
> @@ -1332,7 +1391,7 @@ obfuscate_path_components(
>   			continue;
>   		}
>   		hash = libxfs_da_hashname(comp, namelen);
> -		obfuscate_name(hash, namelen, comp);
> +		obfuscate_name(hash, namelen, comp, false);
>   		ASSERT(hash == libxfs_da_hashname(comp, namelen));
>   		comp += namelen + 1;
>   		len -= namelen + 1;
> 


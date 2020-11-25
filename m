Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37AF02C495D
	for <lists+linux-xfs@lfdr.de>; Wed, 25 Nov 2020 21:55:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731190AbgKYUxD (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 25 Nov 2020 15:53:03 -0500
Received: from sandeen.net ([63.231.237.45]:35698 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730178AbgKYUxD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 25 Nov 2020 15:53:03 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 2D957324E60;
        Wed, 25 Nov 2020 14:52:56 -0600 (CST)
Subject: Re: [PATCH 2/5] libxfs: fix weird comment
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <160633667604.634603.7657982642827987317.stgit@magnolia>
 <160633668822.634603.17791163917116618433.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Message-ID: <efd655a9-933c-9a1c-4f6f-61bf59336c6b@sandeen.net>
Date:   Wed, 25 Nov 2020 14:53:01 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <160633668822.634603.17791163917116618433.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 11/25/20 2:38 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Not sure what happened with this multiline comment, but clean up all the
> stars.

urk, that looks like something I would do, thanks :)

"My God, it's full of stars!"

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  include/platform_defs.h.in |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/include/platform_defs.h.in b/include/platform_defs.h.in
> index 95e7209a3332..539bdbecf6e0 100644
> --- a/include/platform_defs.h.in
> +++ b/include/platform_defs.h.in
> @@ -86,9 +86,9 @@ extern int	platform_nproc(void);
>  /* Simplified from version in include/linux/overflow.h */
>  
>  /*
> - *  * Compute a*b+c, returning SIZE_MAX on overflow. Internal helper for
> - *   * struct_size() below.
> - *    */
> + * Compute a*b+c, returning SIZE_MAX on overflow. Internal helper for
> + * struct_size() below.
> + */
>  static inline size_t __ab_c_size(size_t a, size_t b, size_t c)
>  {
>  	return (a * b) + c;
> 

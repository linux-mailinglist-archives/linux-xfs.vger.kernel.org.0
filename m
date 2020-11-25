Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4579A2C4964
	for <lists+linux-xfs@lfdr.de>; Wed, 25 Nov 2020 21:57:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731284AbgKYUzt (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 25 Nov 2020 15:55:49 -0500
Received: from sandeen.net ([63.231.237.45]:35840 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730719AbgKYUzt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 25 Nov 2020 15:55:49 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 22401324E60;
        Wed, 25 Nov 2020 14:55:42 -0600 (CST)
Subject: Re: [PATCH 4/5] debian: fix version in changelog
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <160633667604.634603.7657982642827987317.stgit@magnolia>
 <160633670037.634603.12898768383906866110.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Message-ID: <dde3c0a0-877f-beb4-63a8-fb5103477425@sandeen.net>
Date:   Wed, 25 Nov 2020 14:55:48 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <160633670037.634603.12898768383906866110.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 11/25/20 2:38 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> We're still at 5.10-rc0, at least according to the tags.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks for spotting this

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  debian/changelog |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/debian/changelog b/debian/changelog
> index c41e3913efa4..ba6861985365 100644
> --- a/debian/changelog
> +++ b/debian/changelog
> @@ -1,4 +1,4 @@
> -xfsprogs (5.10.0-1) unstable; urgency=low
> +xfsprogs (5.10.0-rc0-1) unstable; urgency=low
>  
>    * New upstream prerelease
>  
> 

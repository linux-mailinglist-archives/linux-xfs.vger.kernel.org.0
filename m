Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5B8E39395
	for <lists+linux-xfs@lfdr.de>; Fri,  7 Jun 2019 19:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730811AbfFGRoQ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 7 Jun 2019 13:44:16 -0400
Received: from ms.lwn.net ([45.79.88.28]:57920 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728684AbfFGRoQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 7 Jun 2019 13:44:16 -0400
Received: from lwn.net (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 22208737;
        Fri,  7 Jun 2019 17:44:16 +0000 (UTC)
Date:   Fri, 7 Jun 2019 11:44:15 -0600
From:   Jonathan Corbet <corbet@lwn.net>
To:     Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
Cc:     <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH] Documentation: xfs: Fix typo
Message-ID: <20190607114415.32cb32dd@lwn.net>
In-Reply-To: <20190509030549.2253-1-ruansy.fnst@cn.fujitsu.com>
References: <20190509030549.2253-1-ruansy.fnst@cn.fujitsu.com>
Organization: LWN.net
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, 9 May 2019 11:05:49 +0800
Shiyang Ruan <ruansy.fnst@cn.fujitsu.com> wrote:

> In "Y+P" of this line, there are two non-ASCII characters(0xd9 0x8d)
> following behind the 'Y'.  Shown as a small '=' under the '+' in VIM
> and a '賺' in webpage[1].
> 
> I think it's a mistake and remove these strange characters.
> 
> [1]: https://www.kernel.org/doc/Documentation/filesystems/xfs-delayed-logging-design.txt
> 
> Signed-off-by: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
> ---
>  Documentation/filesystems/xfs-delayed-logging-design.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/filesystems/xfs-delayed-logging-design.txt b/Documentation/filesystems/xfs-delayed-logging-design.txt
> index 2ce36439c09f..9a6dd289b17b 100644
> --- a/Documentation/filesystems/xfs-delayed-logging-design.txt
> +++ b/Documentation/filesystems/xfs-delayed-logging-design.txt
> @@ -34,7 +34,7 @@ transaction:
>  	   D			A+B+C+D		X+n+m+o
>  	    <object written to disk>
>  	   E			   E		   Y (> X+n+m+o)
> -	   F			  E+F		  Yٍ+p
> +	   F			  E+F		  Y+p

OK, that does look funky, applied.

This patch probably should have been copied to the XFS list (added), even
though get_maintainer.pl doesn't know that.

Thanks,

jon

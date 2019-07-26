Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF21077301
	for <lists+linux-xfs@lfdr.de>; Fri, 26 Jul 2019 22:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbfGZUvV (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 26 Jul 2019 16:51:21 -0400
Received: from ms.lwn.net ([45.79.88.28]:52210 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726184AbfGZUvV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 26 Jul 2019 16:51:21 -0400
Received: from lwn.net (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 664C3867;
        Fri, 26 Jul 2019 20:51:20 +0000 (UTC)
Date:   Fri, 26 Jul 2019 14:51:19 -0600
From:   Jonathan Corbet <corbet@lwn.net>
To:     Sheriff Esseson <sheriffesseson@gmail.com>
Cc:     skhan@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Documentation: filesystem: fix "Removed Sysctls" table
Message-ID: <20190726145119.5ef751e8@lwn.net>
In-Reply-To: <20190723114813.GA14870@localhost>
References: <20190723114813.GA14870@localhost>
Organization: LWN.net
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 23 Jul 2019 12:48:13 +0100
Sheriff Esseson <sheriffesseson@gmail.com> wrote:

> the "Removed Sysctls" section is a table - bring it alive with ReST.
> 
> Signed-off-by: Sheriff Esseson <sheriffesseson@gmail.com>
> ---
>  Documentation/admin-guide/xfs.rst | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/admin-guide/xfs.rst b/Documentation/admin-guide/xfs.rst
> index e76665a8f2f2..fb5b39f73059 100644
> --- a/Documentation/admin-guide/xfs.rst
> +++ b/Documentation/admin-guide/xfs.rst
> @@ -337,11 +337,12 @@ None at present.
>  Removed Sysctls
>  ===============
>  
> +=============================	=======
>    Name				Removed
> -  ----				-------
> +=============================	=======
>    fs.xfs.xfsbufd_centisec	v4.0
>    fs.xfs.age_buffer_centisecs	v4.0
> -
> +=============================	=======

I've applied this, thanks.

jon

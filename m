Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A602D303427
	for <lists+linux-xfs@lfdr.de>; Tue, 26 Jan 2021 06:18:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729344AbhAZFSL (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 26 Jan 2021 00:18:11 -0500
Received: from sandeen.net ([63.231.237.45]:37226 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729377AbhAYOUM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 25 Jan 2021 09:20:12 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 851E85EDAB;
        Mon, 25 Jan 2021 08:17:37 -0600 (CST)
To:     Chandan Babu R <chandanrlinux@gmail.com>, linux-xfs@vger.kernel.org
References: <20210125095809.219833-1-chandanrlinux@gmail.com>
 <20210125095809.219833-2-chandanrlinux@gmail.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 2/2] xfsprogs: xfs_fsr: Limit the scope of cmp()
Message-ID: <eec86b5f-7a4c-c6e6-e8a0-1e4e9a7e042e@sandeen.net>
Date:   Mon, 25 Jan 2021 08:19:30 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210125095809.219833-2-chandanrlinux@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 1/25/21 3:58 AM, Chandan Babu R wrote:
> cmp() function is being referred to by only from within fsr/xfs_fsr.c. Hence
> this commit limits its scope to the current file.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>

Might be nice to move cmp just ahead of fsrfs() so we don't need the
forward declaration but *shrug*

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  fsr/xfs_fsr.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
> index 635e4c70..2d070320 100644
> --- a/fsr/xfs_fsr.c
> +++ b/fsr/xfs_fsr.c
> @@ -81,7 +81,7 @@ char * gettmpname(char *fname);
>  char * getparent(char *fname);
>  int fsrprintf(const char *fmt, ...);
>  int read_fd_bmap(int, struct xfs_bstat *, int *);
> -int cmp(const void *, const void *);
> +static int cmp(const void *, const void *);
>  static void tmp_init(char *mnt);
>  static char * tmp_next(char *mnt);
>  static void tmp_close(char *mnt);
> @@ -699,7 +699,7 @@ out0:
>  /*
>   * To compare bstat structs for qsort.
>   */
> -int
> +static int
>  cmp(const void *s1, const void *s2)
>  {
>  	return( ((struct xfs_bulkstat *)s2)->bs_extents -
> 

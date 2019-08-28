Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62172A032E
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Aug 2019 15:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbfH1N3R (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 28 Aug 2019 09:29:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56092 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726415AbfH1N3R (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Aug 2019 09:29:17 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0EAA7308429D;
        Wed, 28 Aug 2019 13:29:17 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 598A85D6B0;
        Wed, 28 Aug 2019 13:29:16 +0000 (UTC)
Date:   Wed, 28 Aug 2019 09:29:14 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v2 14/15] xfs: mount-api - switch to new mount-api
Message-ID: <20190828132914.GG16389@bfoster>
References: <156652158924.2607.14608448087216437699.stgit@fedora-28>
 <156652203256.2607.18022916035406730007.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <156652203256.2607.18022916035406730007.stgit@fedora-28>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Wed, 28 Aug 2019 13:29:17 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 23, 2019 at 09:00:32AM +0800, Ian Kent wrote:
> The infrastructure needed to use the new mount api is now
> in place, switch over to use it.
> 
> Signed-off-by: Ian Kent <raven@themaw.net>
> ---
>  fs/xfs/xfs_super.c |   51 +++++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 49 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index d2a1a62a3edc..fe7acd8ddd48 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -2123,7 +2123,6 @@ static const struct super_operations xfs_super_operations = {
>  	.freeze_fs		= xfs_fs_freeze,
>  	.unfreeze_fs		= xfs_fs_unfreeze,
>  	.statfs			= xfs_fs_statfs,
> -	.remount_fs		= xfs_fs_remount,

Not clear why this needs to go away here, or at least why we don't
remove the function at the same time.

Indeed.. this patch actually throws a couple warnings:

...
  CC [M]  fs/xfs/xfs_super.o
fs/xfs/xfs_super.c:2088:1: warning: ‘xfs_fs_mount’ defined but not used [-Wunused-function]
 xfs_fs_mount(
 ^~~~~~~~~~~~
fs/xfs/xfs_super.c:1448:1: warning: ‘xfs_fs_remount’ defined but not used [-Wunused-function]
 xfs_fs_remount(
 ^~~~~~~~~~~~~~
...

>  	.show_options		= xfs_fs_show_options,
>  	.nr_cached_objects	= xfs_fs_nr_cached_objects,
>  	.free_cached_objects	= xfs_fs_free_cached_objects,
> @@ -2157,10 +2156,58 @@ static const struct fs_context_operations xfs_context_ops = {
...
>  static struct file_system_type xfs_fs_type = {
>  	.owner			= THIS_MODULE,
>  	.name			= "xfs",
> -	.mount			= xfs_fs_mount,
> +	.init_fs_context	= xfs_init_fs_context,
> +	.parameters		= &xfs_fs_parameters,

Just a random observation.. we have a .name == "xfs" field here and the
parameters struct has a .name == "XFS" field. Perhaps we should be
consistent?

Brian

>  	.kill_sb		= kill_block_super,
>  	.fs_flags		= FS_REQUIRES_DEV,
>  };
> 

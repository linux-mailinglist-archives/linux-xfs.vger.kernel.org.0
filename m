Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2BD7C04B
	for <lists+linux-xfs@lfdr.de>; Wed, 31 Jul 2019 13:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727276AbfGaLn1 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 31 Jul 2019 07:43:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52156 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725935AbfGaLn1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 31 Jul 2019 07:43:27 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 63A9130821AE;
        Wed, 31 Jul 2019 11:43:27 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D7F53600CC;
        Wed, 31 Jul 2019 11:43:26 +0000 (UTC)
Date:   Wed, 31 Jul 2019 07:43:25 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs/122: ignore inode geometry structure
Message-ID: <20190731114324.GD34040@bfoster>
References: <156394159426.1850833.16316913520596851191.stgit@magnolia>
 <156394160033.1850833.3353358773089273571.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156394160033.1850833.3353358773089273571.stgit@magnolia>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Wed, 31 Jul 2019 11:43:27 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 23, 2019 at 09:13:20PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Ignore new in-core structure.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  tests/xfs/122 |    1 +
>  1 file changed, 1 insertion(+)
> 
> 
> diff --git a/tests/xfs/122 b/tests/xfs/122
> index b66b78a6..89a39a23 100755
> --- a/tests/xfs/122
> +++ b/tests/xfs/122
> @@ -177,6 +177,7 @@ xfs_dirent_t
>  xfs_fsop_getparents_handlereq_t
>  xfs_dinode_core_t
>  struct xfs_iext_cursor
> +struct xfs_ino_geometry
>  EOF
>  
>  echo 'int main(int argc, char *argv[]) {' >>$cprog
> 

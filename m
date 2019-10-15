Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCAA3D7CF4
	for <lists+linux-xfs@lfdr.de>; Tue, 15 Oct 2019 19:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727675AbfJORJY (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 15 Oct 2019 13:09:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58898 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726470AbfJORJY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 15 Oct 2019 13:09:24 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 012C7A3CD61;
        Tue, 15 Oct 2019 17:09:24 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9E6751001925;
        Tue, 15 Oct 2019 17:09:23 +0000 (UTC)
Date:   Tue, 15 Oct 2019 13:09:21 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/8] xfs: remove the unused XLOG_STATE_ALL and
 XLOG_STATE_UNUSED flags
Message-ID: <20191015170921.GH36108@bfoster>
References: <20191009142748.18005-1-hch@lst.de>
 <20191009142748.18005-7-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191009142748.18005-7-hch@lst.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.68]); Tue, 15 Oct 2019 17:09:24 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 09, 2019 at 04:27:46PM +0200, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_log_priv.h | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 90e210e433cf..66bd370ae60a 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -49,8 +49,6 @@ static inline uint xlog_get_client_id(__be32 i)
>  #define XLOG_STATE_CALLBACK  0x0020 /* Callback functions now */
>  #define XLOG_STATE_DIRTY     0x0040 /* Dirty IC log, not ready for ACTIVE status*/
>  #define XLOG_STATE_IOERROR   0x0080 /* IO error happened in sync'ing log */
> -#define XLOG_STATE_ALL	     0x7FFF /* All possible valid flags */
> -#define XLOG_STATE_NOTUSED   0x8000 /* This IC log not being used */
>  
>  /*
>   * Flags to log ticket
> -- 
> 2.20.1
> 

Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 614374D423C
	for <lists+linux-xfs@lfdr.de>; Thu, 10 Mar 2022 09:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240221AbiCJILM (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 10 Mar 2022 03:11:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240222AbiCJILK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Mar 2022 03:11:10 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2C091342C1
        for <linux-xfs@vger.kernel.org>; Thu, 10 Mar 2022 00:10:09 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 6BE9168AFE; Thu, 10 Mar 2022 09:10:05 +0100 (CET)
Date:   Thu, 10 Mar 2022 09:10:04 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fdmanana@kernel.org,
        andrey.zhadchenko@virtuozzo.com, brauner@kernel.org,
        david@fromorbit.com, hch@lst.de
Subject: Re: [PATCH 2/2] xfs: refactor user/group quota chown in
 xfs_setattr_nonsize
Message-ID: <20220310081004.GB25823@lst.de>
References: <164685372611.495833.8601145506549093582.stgit@magnolia> <164685373748.495833.4023209082084946055.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164685373748.495833.4023209082084946055.stgit@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 09, 2022 at 11:22:17AM -0800, Darrick J. Wong wrote:
> +	if ((mask & ATTR_UID) && XFS_IS_UQUOTA_ON(mp) &&
> +					!uid_eq(inode->i_uid, iattr->ia_uid)) {

Nit: I think in this case an indentation like:

	if ((mask & ATTR_UID) && XFS_IS_UQUOTA_ON(mp) &&
	    !uid_eq(inode->i_uid, iattr->ia_uid)) {

is way more readable.  Same for the gid case.

Otherwise this looks like a nice cleanup:

Reviewed-by: Christoph Hellwig <hch@lst.de>

Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 612B54D4420
	for <lists+linux-xfs@lfdr.de>; Thu, 10 Mar 2022 10:59:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236636AbiCJKAe (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 10 Mar 2022 05:00:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240006AbiCJKAb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Mar 2022 05:00:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 321B711798F
        for <linux-xfs@vger.kernel.org>; Thu, 10 Mar 2022 01:59:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DB48FB82589
        for <linux-xfs@vger.kernel.org>; Thu, 10 Mar 2022 09:59:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15CBEC340E8;
        Thu, 10 Mar 2022 09:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646906368;
        bh=r90c+jt6pEWH6PmS8i0MKjb2cuVqylVT7chaUhulqW8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HmELPqGnsZig2X+ilhJ2RsW03Y4cw2ZMCMK2dPM3P1ZtF+Doin5OCe+9DrXFdSX0L
         GPDEHWC64mJZKYJTLS37kVT40viqBFmG749oZ/p4/g0TWumyzwXeZgqdaVHLjxbrNT
         ttLUq4xS0pnynhxbgVKE2mNo+ticwQgeRff/tgE0IHCFNc1HwjBysiZgUjMfL0Nns5
         R+ELc+Ynr36pRgCyMjuncDoDTGxHPJvBeoh/ul2RheQXXIS82IU45YMH7odA8NmN6b
         zhFpkdLN/f9uWOwSAx/yiTYTAfOslVSklzrJDTuE+x2g1pbojU8Nj+YInU5hzmz1o9
         iLBt22bLj7QeQ==
Date:   Thu, 10 Mar 2022 10:59:23 +0100
From:   Christian Brauner <brauner@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fdmanana@kernel.org,
        andrey.zhadchenko@virtuozzo.com, david@fromorbit.com, hch@lst.de
Subject: Re: [PATCH 2/2] xfs: refactor user/group quota chown in
 xfs_setattr_nonsize
Message-ID: <20220310095923.tof2zmtqjn6nwsi3@wittgenstein>
References: <164685372611.495833.8601145506549093582.stgit@magnolia>
 <164685373748.495833.4023209082084946055.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <164685373748.495833.4023209082084946055.stgit@magnolia>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 09, 2022 at 11:22:17AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Combine if tests to reduce the indentation levels of the quota chown
> calls in xfs_setattr_nonsize.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Looks good to me,
Reviewed-by: Christian Brauner <brauner@kernel.org>

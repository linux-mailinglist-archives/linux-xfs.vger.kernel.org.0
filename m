Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8F92343A34
	for <lists+linux-xfs@lfdr.de>; Mon, 22 Mar 2021 08:05:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbhCVHFU (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 22 Mar 2021 03:05:20 -0400
Received: from verein.lst.de ([213.95.11.211]:53743 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229696AbhCVHFJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 22 Mar 2021 03:05:09 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 8E8B767373; Mon, 22 Mar 2021 08:05:07 +0100 (CET)
Date:   Mon, 22 Mar 2021 08:05:07 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>,
        Vivek Goyal <vgoyal@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 4/4] fs: introduce two inode i_{u,g}id
 initialization helpers
Message-ID: <20210322070507.GD3299@lst.de>
References: <20210320122623.599086-1-christian.brauner@ubuntu.com> <20210320122623.599086-5-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210320122623.599086-5-christian.brauner@ubuntu.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

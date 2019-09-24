Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA05BD45F
	for <lists+linux-xfs@lfdr.de>; Tue, 24 Sep 2019 23:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbfIXVdR (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 24 Sep 2019 17:33:17 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55664 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbfIXVdQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Sep 2019 17:33:16 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iCsQr-0005DE-6n; Tue, 24 Sep 2019 21:33:13 +0000
Date:   Tue, 24 Sep 2019 22:33:13 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [REPOST PATCH v3 01/16] vfs: Create fs_context-aware
 mount_bdev() replacement
Message-ID: <20190924213313.GH26530@ZenIV.linux.org.uk>
References: <156933112949.20933.12761540130806431294.stgit@fedora-28>
 <156933132524.20933.7026640044241445520.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156933132524.20933.7026640044241445520.stgit@fedora-28>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 24, 2019 at 09:22:05PM +0800, Ian Kent wrote:
> From: David Howells <dhowells@redhat.com>
> 
> Create a function, vfs_get_block_super(), that is fs_context-aware and a
> replacement for mount_bdev().  It caches the block device pointer and file
> open mode in the fs_context struct so that this information can be passed
> into sget_fc()'s test and set functions.

NAK.  Use get_tree_bdev() instead.

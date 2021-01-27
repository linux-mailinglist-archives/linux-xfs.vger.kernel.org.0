Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74CCE3051B1
	for <lists+linux-xfs@lfdr.de>; Wed, 27 Jan 2021 06:05:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231340AbhA0FF0 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 27 Jan 2021 00:05:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:34390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233401AbhA0Df0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 26 Jan 2021 22:35:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2BC05205CA
        for <linux-xfs@vger.kernel.org>; Wed, 27 Jan 2021 03:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611718485;
        bh=7it5IZDU7hDIYsr5jQoKhVwnSSN4spl7nuqszcHlzhU=;
        h=Date:From:To:Subject:From;
        b=TAxEHCvQ79kPtGwS8jVeL+OiCVJBtIEw0BVWkg7546BfKJhb6C/zVNOhhpzAz1wr4
         7/Et1n4s8lCFc7g3quBg2t6cgo8ScVYaVHUIlc51vJj41esLbFQZFQc5aHf29TddyA
         Sj/J/LgXqpsu/d7MIFo5jUvBiieGnFk9HLvFevK0dozda5Ig6C1Mp7IiQDPtf3LFZO
         jVy9ykAIhdrbpAc/1ExYFx5xZV4C4O+OmMN5g9wr7YRYBdANTmHpxoN6Sqb3bfpIuX
         oEzEpTszymJL/j2fzMHHQbh188LWqPpt4DTrz/DnvflVt413l6Hsco56+rkevwCQ+0
         QXr/3T38Wrgmg==
Date:   Tue, 26 Jan 2021 19:34:44 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: test message
Message-ID: <20210127033444.GG7698@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hm.  I'm missing a substantial amount of list traffic, and I can't tell
if vger is still slow or if it's mail.kernel.org forwarding that's
busted.

Hmm, a message I just sent to my oracle address works fine, so I guess
it's vger that's broken?  Maybe?  I guess we'll see when this shows
up; the vger queue doesn't seem to have anything for xfs right now.

<grumble>

--D

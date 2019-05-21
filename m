Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4F124760
	for <lists+linux-xfs@lfdr.de>; Tue, 21 May 2019 07:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725885AbfEUFMy (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 21 May 2019 01:12:54 -0400
Received: from mail-yb1-f194.google.com ([209.85.219.194]:41523 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbfEUFMy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 May 2019 01:12:54 -0400
Received: by mail-yb1-f194.google.com with SMTP id d2so1473555ybh.8;
        Mon, 20 May 2019 22:12:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mFl4Di+WVAGVBpne9KAPbnxflB8k+Vdx7srqDbqyTEw=;
        b=aJqruwhWnXfZLQHPHSlie0rHuBN5YSUtZuE85xOuHbXMwASWn8VnKM1IIXs5VyxaPt
         J0p+CR3i7tx1L+KPu5vAwv7nTK3cjtBZ4gshkycGe2EAkDuFAF57fBr5f8SwIB8Ktn+C
         BxaTsXXGM0qavMRf0ZAGKb4HmKYouAlPA1v088/r/oe5cG48kaZj13mP4V20kuqG+T0b
         VHB9BxB1kjmnQEeKwDfim+96eC1oahQNKUSnyJQHpgaYF4vDDYwKtIr8pn/1VHfso0SM
         nx8Be6yZEbOcVADxM0b176SrniByd9ufQbZqUzRQkZ7eCuHJZHpdiZ4AKiP7KlOGXgyX
         O2cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mFl4Di+WVAGVBpne9KAPbnxflB8k+Vdx7srqDbqyTEw=;
        b=q9wtg7H/uc1QBu+mFx5LW4ZR+msNpDBU5nEOXvytNSicryWPBUD7OZt/r1NiCr+9q6
         UZYdMdVYGUgyVIv6QN+GwGvUQe1EGsHY5hzoJ/oUwr0dzYu47A/Lay6jUVZrrCRdxajA
         AypCJiH1mfuxVdl9pFq5TPP2KSjqeuzbh0Zct/0ui4W18fMvl2LyHoK5OUFBnZn+jIgl
         BO1msMB0wElgI0Ie53EN9lW8DoMgVDh9OYcauAlmxwCiC3c0T3k1xN6w+Itu5TebTw8j
         AFuR2ZhJPisVeTU8BlN2QR3uL2w2sFG0Jg5NWn+tXnKaevpSk4p/P0xSckN02s5jzae3
         7duA==
X-Gm-Message-State: APjAAAWHQnMUu2qlnbSI1UIqGWMufT+hyR3iFhshNICCELjlVW+wElJe
        Shlyk3OcJ9hOg9y5N1YAoOtFquChPnoCzfUVpDY=
X-Google-Smtp-Source: APXvYqxmUUoIlYJIurPoI2Xvn8zSk3N0b92q0Ot0A+swf+Qjj/lUsQhQAru25+RNNcWHoa7hWpamJkoEsCHyPywVoKY=
X-Received: by 2002:a25:c983:: with SMTP id z125mr34459362ybf.45.1558415572714;
 Mon, 20 May 2019 22:12:52 -0700 (PDT)
MIME-Version: 1.0
References: <155839145160.62682.10916303376882370723.stgit@magnolia> <155839146420.62682.1995545484813176181.stgit@magnolia>
In-Reply-To: <155839146420.62682.1995545484813176181.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 21 May 2019 08:12:41 +0300
Message-ID: <CAOQ4uxjj6HtEOk7FWkabZn1x34+gEUVLqqiU0JkcEtddQf0j_g@mail.gmail.com>
Subject: Re: [PATCH 2/3] generic/530, xfs/501: pass fs shutdown handle to t_open_tmpfiles
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Eryu Guan <guaneryu@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Jeffle Xu <jefflexu@linux.alibaba.com>,
        fstests <fstests@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 21, 2019 at 1:33 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> So it turns out that overlayfs can't pass FS_IOC_SHUTDOWN to the lower
> filesystems and so xfstests works around this by creating shutdown
> helpers for the scratch fs to direct the shutdown ioctl to wherever it
> needs to go to shut down the filesystem -- SCRATCH_MNT on normal
> filesystems and OVL_BASE_SCRATCH_MNT when -overlay is enabled.  This
> means that t_open_tmpfiles cannot simply use one of the open tempfiles
> to shut down the filesystem.
>
> Commit f8f57747222 tried to "fix" this by ripping the shutdown code out,
> but this made the tests useless.  Fix this instead by creating a
> xfstests helper to return a path that can be used to shut down the
> filesystem and then pass that path to t_open_tmpfiles so that we can
> shut down the filesystem when overlayfs is enabled.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks for sorting that out.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  common/rc             |   11 +++++++++++
>  src/t_open_tmpfiles.c |   20 +++++++++++++-------
>  tests/generic/530     |    2 +-
>  tests/xfs/501         |    2 +-
>  4 files changed, 26 insertions(+), 9 deletions(-)
>
>
> diff --git a/common/rc b/common/rc
> index 27c8bb7a..f577e5e3 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -393,6 +393,17 @@ _scratch_shutdown()
>         fi
>  }
>
> +# Return a file path that can be used to shut down the scratch filesystem.
> +# Caller should _require_scratch_shutdown before using this.
> +_scratch_shutdown_handle()
> +{
> +       if [ $FSTYP = "overlay" ]; then
> +               echo $OVL_BASE_SCRATCH_MNT
> +       else
> +               echo $SCRATCH_MNT
> +       fi
> +}
> +
>  _test_mount()
>  {
>      if [ "$FSTYP" == "overlay" ]; then
> diff --git a/src/t_open_tmpfiles.c b/src/t_open_tmpfiles.c
> index da9390fd..258b0c95 100644
> --- a/src/t_open_tmpfiles.c
> +++ b/src/t_open_tmpfiles.c
> @@ -24,7 +24,7 @@ static int min_fd = -1;
>  static int max_fd = -1;
>  static unsigned int nr_opened = 0;
>  static float start_time;
> -static int shutdown_fs = 0;
> +static int shutdown_fd = -1;
>
>  void clock_time(float *time)
>  {
> @@ -69,7 +69,7 @@ void die(void)
>                                 end_time - start_time);
>                 fflush(stdout);
>
> -               if (shutdown_fs) {
> +               if (shutdown_fd >= 0) {
>                         /*
>                          * Flush the log so that we have to process the
>                          * unlinked inodes the next time we mount.
> @@ -77,7 +77,7 @@ void die(void)
>                         int flag = XFS_FSOP_GOING_FLAGS_LOGFLUSH;
>                         int ret;
>
> -                       ret = ioctl(min_fd, XFS_IOC_GOINGDOWN, &flag);
> +                       ret = ioctl(shutdown_fd, XFS_IOC_GOINGDOWN, &flag);
>                         if (ret) {
>                                 perror("shutdown");
>                                 exit(2);
> @@ -148,8 +148,9 @@ void leak_tmpfile(void)
>
>  /*
>   * Try to put as many files on the unlinked list and then kill them.
> - * The first argument is a directory to chdir into; passing any second arg
> - * will shut down the fs instead of closing files.
> + * The first argument is a directory to chdir into; the second argumennt (if
> + * provided) is a file path that will be opened and then used to shut down the
> + * fs before the program exits.
>   */
>  int main(int argc, char *argv[])
>  {
> @@ -160,8 +161,13 @@ int main(int argc, char *argv[])
>                 if (ret)
>                         perror(argv[1]);
>         }
> -       if (argc > 2 && !strcmp(argv[2], "shutdown"))
> -               shutdown_fs = 1;
> +       if (argc > 2) {
> +               shutdown_fd = open(argv[2], O_RDONLY);
> +               if (shutdown_fd < 0) {
> +                       perror(argv[2]);
> +                       return 1;
> +               }
> +       }
>
>         clock_time(&start_time);
>         while (1)
> diff --git a/tests/generic/530 b/tests/generic/530
> index b0d188b1..cb874ace 100755
> --- a/tests/generic/530
> +++ b/tests/generic/530
> @@ -49,7 +49,7 @@ ulimit -n $max_files
>
>  # Open a lot of unlinked files
>  echo create >> $seqres.full
> -$here/src/t_open_tmpfiles $SCRATCH_MNT shutdown >> $seqres.full
> +$here/src/t_open_tmpfiles $SCRATCH_MNT $(_scratch_shutdown_handle) >> $seqres.full
>
>  # Unmount to prove that we can clean it all
>  echo umount >> $seqres.full
> diff --git a/tests/xfs/501 b/tests/xfs/501
> index 974f3414..4be03b31 100755
> --- a/tests/xfs/501
> +++ b/tests/xfs/501
> @@ -54,7 +54,7 @@ ulimit -n $max_files
>
>  # Open a lot of unlinked files
>  echo create >> $seqres.full
> -$here/src/t_open_tmpfiles $SCRATCH_MNT shutdown >> $seqres.full
> +$here/src/t_open_tmpfiles $SCRATCH_MNT $(_scratch_shutdown_handle) >> $seqres.full
>
>  # Unmount to prove that we can clean it all
>  echo umount >> $seqres.full
>
